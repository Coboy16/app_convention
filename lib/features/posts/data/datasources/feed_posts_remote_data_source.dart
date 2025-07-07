import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '/core/errors/exceptions.dart';
import '../models/feed_post_model.dart';
import '../models/feed_comment_model.dart';
import '../models/feed_story_model.dart';

abstract class FeedPostsRemoteDataSource {
  // Posts
  Future<List<FeedPostModel>> getAllPosts();
  Future<FeedPostModel> createPost({
    required String content,
    required List<String> imagePaths,
    required List<String> hashtags,
  });
  Future<void> deletePost(String postId);
  Future<FeedPostModel> toggleLike(String postId);

  // Comments
  Future<List<FeedCommentModel>> getPostComments(String postId);
  Future<FeedCommentModel> addComment({
    required String postId,
    required String content,
  });
  Future<void> deleteComment(String commentId);
  Future<FeedCommentModel> toggleCommentLike(String commentId);

  // Stories
  Future<List<FeedStoryModel>> getAllStories();
  Future<FeedStoryModel> createStory({
    required String imagePath,
    required String caption,
  });
  Future<void> markStoryAsViewed(String storyId);

  // Utils
  Future<List<String>> uploadImages(List<String> imagePaths);
}

class FeedPostsRemoteDataSourceImpl implements FeedPostsRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;

  FeedPostsRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
    required this.auth,
  });

  String get _currentUserId {
    final user = auth.currentUser;
    if (user == null) throw const ServerException('Usuario no autenticado');
    return user.uid;
  }

  @override
  Future<List<FeedPostModel>> getAllPosts() async {
    try {
      debugPrint('🔍 Obteniendo todos los posts del feed');

      final querySnapshot = await firestore
          .collection('feed_posts')
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('📊 Posts encontrados: ${querySnapshot.docs.length}');

      final posts = querySnapshot.docs
          .map((doc) => FeedPostModel.fromFirestore(doc, _currentUserId))
          .toList();

      debugPrint('✅ Posts procesados exitosamente');
      return posts;
    } catch (e) {
      debugPrint('❌ Error al obtener posts: ${e.toString()}');
      throw ServerException('Error al obtener posts: ${e.toString()}');
    }
  }

  @override
  Future<FeedPostModel> createPost({
    required String content,
    required List<String> imagePaths,
    required List<String> hashtags,
  }) async {
    try {
      debugPrint('🔄 Creando nuevo post');
      debugPrint('📋 Contenido: $content');
      debugPrint('📸 Imágenes: ${imagePaths.length}');
      debugPrint('🏷️ Hashtags: $hashtags');

      // Obtener información del usuario actual
      final userDoc = await firestore
          .collection('users')
          .doc(_currentUserId)
          .get();
      if (!userDoc.exists) {
        throw const ServerException('Usuario no encontrado');
      }

      final userData = userDoc.data()!;
      final username = userData['name'] ?? 'Usuario';
      final avatarUrl = userData['photoUrl'];
      final userRole = userData['role'];

      // Subir imágenes si hay
      List<String> imageUrls = [];
      if (imagePaths.isNotEmpty) {
        debugPrint('📤 Subiendo ${imagePaths.length} imágenes...');
        imageUrls = await uploadImages(imagePaths);
        debugPrint('✅ Imágenes subidas: ${imageUrls.length}');
      }

      // Crear el post
      final now = DateTime.now();
      final postData = {
        'userId': _currentUserId,
        'username': username,
        'avatarUrl': avatarUrl,
        'content': content,
        'imageUrls': imageUrls,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'likes': <String>[], // Lista de IDs de usuarios que dieron like
        'commentsCount': 0,
        'type': userRole == 'organizer' ? 'admin' : 'user',
        'userRole': userRole,
        'hashtags': hashtags,
      };

      debugPrint('💾 Guardando post en Firestore...');
      final docRef = await firestore.collection('feed_posts').add(postData);
      debugPrint('✅ Post guardado con ID: ${docRef.id}');

      // Retornar el post creado
      final doc = await docRef.get();
      final createdPost = FeedPostModel.fromFirestore(doc, _currentUserId);

      debugPrint('🎉 Post creado exitosamente');
      return createdPost;
    } catch (e) {
      debugPrint('❌ Error al crear post: ${e.toString()}');
      throw ServerException('Error al crear post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      debugPrint('🔄 Eliminando post: $postId');

      // Verificar que el post pertenece al usuario actual
      final doc = await firestore.collection('feed_posts').doc(postId).get();
      if (!doc.exists) {
        throw const ServerException('Post no encontrado');
      }

      final post = FeedPostModel.fromFirestore(doc, _currentUserId);
      if (post.userId != _currentUserId) {
        throw const ServerException(
          'No tienes permisos para eliminar este post',
        );
      }

      // Eliminar imágenes del storage
      for (final imageUrl in post.imageUrls) {
        try {
          final ref = storage.refFromURL(imageUrl);
          await ref.delete();
          debugPrint('✅ Imagen eliminada: $imageUrl');
        } catch (e) {
          debugPrint('⚠️ No se pudo eliminar la imagen: $imageUrl');
        }
      }

      // Eliminar comentarios del post
      final commentsQuery = await firestore
          .collection('feed_comments')
          .where('postId', isEqualTo: postId)
          .get();

      for (final commentDoc in commentsQuery.docs) {
        await commentDoc.reference.delete();
      }

      // Eliminar el post
      await firestore.collection('feed_posts').doc(postId).delete();
      debugPrint('✅ Post eliminado exitosamente');
    } catch (e) {
      debugPrint('❌ Error al eliminar post: ${e.toString()}');
      throw ServerException('Error al eliminar post: ${e.toString()}');
    }
  }

  @override
  Future<FeedPostModel> toggleLike(String postId) async {
    try {
      debugPrint('🔄 Toggling like para post: $postId');

      final docRef = firestore.collection('feed_posts').doc(postId);

      return await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw const ServerException('Post no encontrado');
        }

        final data = doc.data()!;
        final likes = List<String>.from(data['likes'] ?? []);

        if (likes.contains(_currentUserId)) {
          // Quitar like
          likes.remove(_currentUserId);
          debugPrint('👎 Like removido');
        } else {
          // Agregar like
          likes.add(_currentUserId);
          debugPrint('👍 Like agregado');
        }

        transaction.update(docRef, {
          'likes': likes,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });

        // Retornar el post actualizado (simulado)
        final updatedData = {...data, 'likes': likes};
        return FeedPostModel.fromMap(updatedData, postId, _currentUserId);
      });
    } catch (e) {
      debugPrint('❌ Error al toggle like: ${e.toString()}');
      throw ServerException('Error al toggle like: ${e.toString()}');
    }
  }

  @override
  Future<List<FeedCommentModel>> getPostComments(String postId) async {
    try {
      debugPrint('🔍 Obteniendo comentarios para post: $postId');

      final querySnapshot = await firestore
          .collection('feed_comments')
          .where('postId', isEqualTo: postId)
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('📊 Comentarios encontrados: ${querySnapshot.docs.length}');

      final comments = querySnapshot.docs
          .map((doc) => FeedCommentModel.fromFirestore(doc, _currentUserId))
          .toList();

      return comments;
    } catch (e) {
      debugPrint('❌ Error al obtener comentarios: ${e.toString()}');
      throw ServerException('Error al obtener comentarios: ${e.toString()}');
    }
  }

  @override
  Future<FeedCommentModel> addComment({
    required String postId,
    required String content,
  }) async {
    try {
      debugPrint('🔄 Agregando comentario al post: $postId');

      // Obtener información del usuario actual
      final userDoc = await firestore
          .collection('users')
          .doc(_currentUserId)
          .get();
      if (!userDoc.exists) {
        throw const ServerException('Usuario no encontrado');
      }

      final userData = userDoc.data()!;
      final username = userData['name'] ?? 'Usuario';
      final avatarUrl = userData['photoUrl'];

      // Crear el comentario
      final now = DateTime.now();
      final commentData = {
        'postId': postId,
        'userId': _currentUserId,
        'username': username,
        'avatarUrl': avatarUrl,
        'content': content,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'likes': <String>[],
      };

      final docRef = await firestore
          .collection('feed_comments')
          .add(commentData);

      // Actualizar contador de comentarios en el post
      await firestore.collection('feed_posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
        'updatedAt': Timestamp.fromDate(now),
      });

      // Retornar el comentario creado
      final doc = await docRef.get();
      final createdComment = FeedCommentModel.fromFirestore(
        doc,
        _currentUserId,
      );

      debugPrint('✅ Comentario agregado exitosamente');
      return createdComment;
    } catch (e) {
      debugPrint('❌ Error al agregar comentario: ${e.toString()}');
      throw ServerException('Error al agregar comentario: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      debugPrint('🔄 Eliminando comentario: $commentId');

      final doc = await firestore
          .collection('feed_comments')
          .doc(commentId)
          .get();
      if (!doc.exists) {
        throw const ServerException('Comentario no encontrado');
      }

      final comment = FeedCommentModel.fromFirestore(doc, _currentUserId);
      if (comment.userId != _currentUserId) {
        throw const ServerException(
          'No tienes permisos para eliminar este comentario',
        );
      }

      // Eliminar el comentario
      await firestore.collection('feed_comments').doc(commentId).delete();

      // Actualizar contador de comentarios en el post
      await firestore.collection('feed_posts').doc(comment.postId).update({
        'commentsCount': FieldValue.increment(-1),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      debugPrint('✅ Comentario eliminado exitosamente');
    } catch (e) {
      debugPrint('❌ Error al eliminar comentario: ${e.toString()}');
      throw ServerException('Error al eliminar comentario: ${e.toString()}');
    }
  }

  @override
  Future<FeedCommentModel> toggleCommentLike(String commentId) async {
    try {
      debugPrint('🔄 Toggling like para comentario: $commentId');

      final docRef = firestore.collection('feed_comments').doc(commentId);

      return await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw const ServerException('Comentario no encontrado');
        }

        final data = doc.data()!;
        final likes = List<String>.from(data['likes'] ?? []);

        if (likes.contains(_currentUserId)) {
          likes.remove(_currentUserId);
          debugPrint('👎 Like removido del comentario');
        } else {
          likes.add(_currentUserId);
          debugPrint('👍 Like agregado al comentario');
        }

        transaction.update(docRef, {
          'likes': likes,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });

        final updatedData = {...data, 'likes': likes};
        return FeedCommentModel.fromMap(updatedData, commentId, _currentUserId);
      });
    } catch (e) {
      debugPrint('❌ Error al toggle like del comentario: ${e.toString()}');
      throw ServerException(
        'Error al toggle like del comentario: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<FeedStoryModel>> getAllStories() async {
    try {
      debugPrint('🔍 Obteniendo todas las historias');

      // Filtrar historias no expiradas (últimas 24 horas)
      final dayAgo = DateTime.now().subtract(const Duration(hours: 24));

      final querySnapshot = await firestore
          .collection('feed_stories')
          .where('expiresAt', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .orderBy('expiresAt', descending: false)
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('📊 Historias encontradas: ${querySnapshot.docs.length}');

      final stories = querySnapshot.docs
          .map((doc) => FeedStoryModel.fromFirestore(doc, _currentUserId))
          .toList();

      return stories;
    } catch (e) {
      debugPrint('❌ Error al obtener historias: ${e.toString()}');
      throw ServerException('Error al obtener historias: ${e.toString()}');
    }
  }

  @override
  Future<FeedStoryModel> createStory({
    required String imagePath,
    required String caption,
  }) async {
    try {
      debugPrint('🔄 Creando nueva historia');

      // Obtener información del usuario actual
      final userDoc = await firestore
          .collection('users')
          .doc(_currentUserId)
          .get();
      if (!userDoc.exists) {
        throw const ServerException('Usuario no encontrado');
      }

      final userData = userDoc.data()!;
      final username = userData['name'] ?? 'Usuario';
      final avatarUrl = userData['photoUrl'];

      // Subir imagen
      debugPrint('📤 Subiendo imagen de historia...');
      final imageUrls = await uploadImages([imagePath]);
      final imageUrl = imageUrls.first;

      // Crear la historia
      final now = DateTime.now();
      final expiresAt = now.add(
        const Duration(hours: 24),
      ); // Expira en 24 horas

      final storyData = {
        'userId': _currentUserId,
        'username': username,
        'avatarUrl': avatarUrl,
        'imageUrl': imageUrl,
        'caption': caption,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'viewedBy': <String>[],
      };

      final docRef = await firestore.collection('feed_stories').add(storyData);

      // Retornar la historia creada
      final doc = await docRef.get();
      final createdStory = FeedStoryModel.fromFirestore(doc, _currentUserId);

      debugPrint('✅ Historia creada exitosamente');
      return createdStory;
    } catch (e) {
      debugPrint('❌ Error al crear historia: ${e.toString()}');
      throw ServerException('Error al crear historia: ${e.toString()}');
    }
  }

  @override
  Future<void> markStoryAsViewed(String storyId) async {
    try {
      debugPrint('🔄 Marcando historia como vista: $storyId');

      await firestore.collection('feed_stories').doc(storyId).update({
        'viewedBy': FieldValue.arrayUnion([_currentUserId]),
      });

      debugPrint('✅ Historia marcada como vista');
    } catch (e) {
      debugPrint('❌ Error al marcar historia como vista: ${e.toString()}');
      throw ServerException(
        'Error al marcar historia como vista: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      debugPrint('📤 Subiendo ${imagePaths.length} imágenes...');
      final List<String> downloadUrls = [];

      for (int i = 0; i < imagePaths.length; i++) {
        debugPrint('📤 Subiendo imagen ${i + 1}/${imagePaths.length}');

        final file = File(imagePaths[i]);
        if (!await file.exists()) {
          throw ServerException('Archivo no encontrado: ${imagePaths[i]}');
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child('feed_images/$fileName');

        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);

        debugPrint('✅ Imagen ${i + 1} subida exitosamente');
      }

      debugPrint('🎉 Todas las imágenes subidas exitosamente');
      return downloadUrls;
    } catch (e) {
      debugPrint('❌ Error al subir imágenes: ${e.toString()}');
      throw ServerException('Error al subir imágenes: ${e.toString()}');
    }
  }
}
