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
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        throw const ServerException('Perfil no encontrado');
      }

      return ProfileModel.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error al obtener perfil: ${e.toString()}');
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
      final Map<String, dynamic> updateData = {'updatedAt': Timestamp.now()};

      if (name != null) updateData['name'] = name;
      if (bio != null) updateData['bio'] = bio;
      if (allergies != null) updateData['allergies'] = allergies;

      await firestore.collection('users').doc(userId).update(updateData);

      // Obtener el perfil actualizado
      return await getProfile(userId);
    } catch (e) {
      throw ServerException('Error al actualizar perfil: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);
      final fileName = 'profile_$userId.jpg';
      final ref = storage.ref().child('profiles/$fileName');

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw ServerException('Error al subir imagen: ${e.toString()}');
    }
  }

  @override
  Future<ProfileModel> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'photoUrl': imageUrl,
        'updatedAt': Timestamp.now(),
      });

      return await getProfile(userId);
    } catch (e) {
      throw ServerException(
        'Error al actualizar imagen de perfil: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => PostModel.fromFirestore(doc))
          .toList();
    } catch (e) {
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
      // Subir imágenes primero
      final imageUrls = await uploadPostImages(imagePaths);

      // Crear el post
      final now = DateTime.now();
      final postData = {
        'userId': userId,
        'description': description,
        'imageUrls': imageUrls,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      final docRef = await firestore.collection('posts').add(postData);

      // Retornar el post creado
      final doc = await docRef.get();
      return PostModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Error al crear post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost({
    required String userId,
    required String postId,
  }) async {
    try {
      // Verificar que el post pertenece al usuario
      final doc = await firestore.collection('posts').doc(postId).get();

      if (!doc.exists) {
        throw const ServerException('Post no encontrado');
      }

      final post = PostModel.fromFirestore(doc);
      if (post.userId != userId) {
        throw const ServerException(
          'No tienes permisos para eliminar este post',
        );
      }

      // Eliminar imágenes del storage
      for (final imageUrl in post.imageUrls) {
        try {
          final ref = storage.refFromURL(imageUrl);
          await ref.delete();
        } catch (e) {
          // Continuar si no se puede eliminar la imagen
        }
      }

      // Eliminar el post
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw ServerException('Error al eliminar post: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadPostImages(List<String> imagePaths) async {
    try {
      final List<String> downloadUrls = [];

      for (int i = 0; i < imagePaths.length; i++) {
        final file = File(imagePaths[i]);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child('posts/$fileName');

        await ref.putFile(file);
        final downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      throw ServerException('Error al subir imágenes: ${e.toString()}');
    }
  }
}
