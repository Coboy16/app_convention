import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '/core/errors/exceptions.dart';
import '../models/profile_model.dart';
import '../models/post_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(String userId);
  Future<ProfileModel> updateProfile({
    required String userId,
    String? name,
    String? bio,
    List<String>? allergies,
  });
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  });
  Future<ProfileModel> updateProfileImage({
    required String userId,
    required String imageUrl,
  });
  Future<List<PostModel>> getUserPosts(String userId);
  Future<PostModel> createPost({
    required String userId,
    String? description,
    required List<String> imagePaths,
  });
  Future<void> deletePost({required String userId, required String postId});
  Future<List<String>> uploadPostImages(List<String> imagePaths);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProfileRemoteDataSourceImpl({required this.firestore, required this.storage});

  @override
  Future<ProfileModel> getProfile(String userId) async {
    try {
      debugPrint('🔍 Obteniendo perfil para userId: $userId');
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        debugPrint('❌ Perfil no encontrado para userId: $userId');
        throw const ServerException('Perfil no encontrado');
      }

      debugPrint('✅ Perfil encontrado para userId: $userId');
      return ProfileModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error al obtener perfil: ${e.toString()}');
      throw ServerException('Error al obtener perfil: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String userId,
    String? name,
    String? bio,
    List<String>? allergies,
  }) async {
    try {
      debugPrint('🔄 Actualizando perfil para userId: $userId');
      debugPrint('📋 Datos a actualizar:');
      debugPrint('   - name: $name');
      debugPrint('   - bio: $bio');
      debugPrint('   - allergies: $allergies');

      final Map<String, dynamic> updateData = {'updatedAt': Timestamp.now()};

      if (name != null) updateData['name'] = name;
      if (bio != null) updateData['bio'] = bio;
      if (allergies != null) updateData['allergies'] = allergies;

      await firestore.collection('users').doc(userId).update(updateData);
      debugPrint('✅ Perfil actualizado en Firestore');

      // Obtener el perfil actualizado
      return await getProfile(userId);
    } catch (e) {
      debugPrint('❌ Error al actualizar perfil: ${e.toString()}');
      throw ServerException('Error al actualizar perfil: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      debugPrint('📤 Subiendo imagen de perfil para userId: $userId');
      debugPrint('📁 Ruta local: $imagePath');

      final file = File(imagePath);
      final fileName = 'profile_$userId.jpg';
      final ref = storage.ref().child('profiles/$fileName');

      debugPrint('☁️ Subiendo a Firebase Storage: profiles/$fileName');
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      debugPrint('✅ Imagen de perfil subida exitosamente');
      debugPrint('🔗 URL de descarga: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Error al subir imagen de perfil: ${e.toString()}');
      throw ServerException('Error al subir imagen: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      debugPrint('🔄 Actualizando URL de imagen de perfil en Firestore');
      debugPrint('👤 userId: $userId');
      debugPrint('🔗 imageUrl: $imageUrl');

      await firestore.collection('users').doc(userId).update({
        'photoUrl': imageUrl,
        'updatedAt': Timestamp.now(),
      });

      debugPrint('✅ URL de imagen actualizada en Firestore');
      return await getProfile(userId);
    } catch (e) {
      debugPrint('❌ Error al actualizar imagen de perfil: ${e.toString()}');
      throw ServerException(
        'Error al actualizar imagen de perfil: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      debugPrint('🔍 Obteniendo posts para userId: $userId');

      final querySnapshot = await firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('📊 Posts encontrados: ${querySnapshot.docs.length}');

      final posts = querySnapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();

      for (int i = 0; i < posts.length; i++) {
        debugPrint(
          '   Post $i: ${posts[i].id} - ${posts[i].imageUrls.length} imágenes',
        );
      }

      return posts;
    } catch (e) {
      debugPrint('❌ Error al obtener posts: ${e.toString()}');
      throw ServerException('Error al obtener posts: ${e.toString()}');
    }
  }

  @override
  Future<PostModel> createPost({
    required String userId,
    String? description,
    required List<String> imagePaths,
  }) async {
    try {
      debugPrint('🔄 Creando post para userId: $userId');
      debugPrint('📋 Datos del post:');
      debugPrint('   - description: $description');
      debugPrint('   - imagePaths: ${imagePaths.length} imágenes');

      for (int i = 0; i < imagePaths.length; i++) {
        debugPrint('   - Imagen $i: ${imagePaths[i]}');
      }

      // Subir imágenes primero
      debugPrint('📤 Subiendo imágenes a Firebase Storage...');
      final imageUrls = await uploadPostImages(imagePaths);
      debugPrint(
        '✅ Imágenes subidas exitosamente. URLs obtenidas: ${imageUrls.length}',
      );

      // Crear el post
      final now = DateTime.now();
      final postData = {
        'userId': userId,
        'description': description,
        'imageUrls': imageUrls,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      debugPrint('💾 Guardando post en Firestore...');
      final docRef = await firestore.collection('posts').add(postData);
      debugPrint('✅ Post guardado con ID: ${docRef.id}');

      // Retornar el post creado
      final doc = await docRef.get();
      final createdPost = PostModel.fromFirestore(doc);

      debugPrint('🎉 Post creado exitosamente:');
      debugPrint('   - ID: ${createdPost.id}');
      debugPrint('   - URLs: ${createdPost.imageUrls.length}');

      return createdPost;
    } catch (e) {
      debugPrint('❌ Error al crear post: ${e.toString()}');
      throw ServerException('Error al crear post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost({
    required String userId,
    required String postId,
  }) async {
    try {
      debugPrint('🔄 Eliminando post: $postId para userId: $userId');

      // Verificar que el post pertenece al usuario
      final doc = await firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        debugPrint('❌ Post no encontrado: $postId');
        throw const ServerException('Post no encontrado');
      }

      final post = PostModel.fromFirestore(doc);
      if (post.userId != userId) {
        debugPrint('❌ Usuario no autorizado para eliminar el post');
        throw const ServerException(
          'No tienes permisos para eliminar este post',
        );
      }

      debugPrint(
        '🗑️ Eliminando ${post.imageUrls.length} imágenes del storage...',
      );
      // Eliminar imágenes del storage
      for (final imageUrl in post.imageUrls) {
        try {
          final ref = storage.refFromURL(imageUrl);
          await ref.delete();
          debugPrint('✅ Imagen eliminada: $imageUrl');
        } catch (e) {
          debugPrint(
            '⚠️ No se pudo eliminar la imagen: $imageUrl - ${e.toString()}',
          );
          // Continuar si no se puede eliminar la imagen
        }
      }

      // Eliminar el post
      await firestore.collection('posts').doc(postId).delete();
      debugPrint('✅ Post eliminado de Firestore: $postId');
    } catch (e) {
      debugPrint('❌ Error al eliminar post: ${e.toString()}');
      throw ServerException('Error al eliminar post: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadPostImages(List<String> imagePaths) async {
    try {
      debugPrint('📤 Subiendo ${imagePaths.length} imágenes de post...');
      final List<String> downloadUrls = [];

      for (int i = 0; i < imagePaths.length; i++) {
        debugPrint(
          '📤 Subiendo imagen ${i + 1}/${imagePaths.length}: ${imagePaths[i]}',
        );

        final file = File(imagePaths[i]);

        // Verificar que el archivo existe
        if (!await file.exists()) {
          debugPrint('❌ Archivo no encontrado: ${imagePaths[i]}');
          throw ServerException('Archivo no encontrado: ${imagePaths[i]}');
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child('posts/$fileName');

        debugPrint('☁️ Subiendo a: posts/$fileName');

        try {
          await ref.putFile(file);
          final downloadUrl = await ref.getDownloadURL();
          downloadUrls.add(downloadUrl);

          debugPrint('✅ Imagen ${i + 1} subida exitosamente');
          debugPrint('🔗 URL: $downloadUrl');
        } catch (uploadError) {
          debugPrint(
            '❌ Error al subir imagen ${i + 1}: ${uploadError.toString()}',
          );
          throw ServerException(
            'Error al subir imagen ${i + 1}: ${uploadError.toString()}',
          );
        }
      }

      debugPrint('🎉 Todas las imágenes subidas exitosamente');
      debugPrint('📊 Total URLs obtenidas: ${downloadUrls.length}');

      return downloadUrls;
    } catch (e) {
      debugPrint('❌ Error al subir imágenes: ${e.toString()}');
      throw ServerException('Error al subir imágenes: ${e.toString()}');
    }
  }
}
