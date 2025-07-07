import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageLocalDataSource localDataSource;
  final ProfileRemoteDataSource remoteDataSource;

  ImageRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, String>> pickImageFromGallery() async {
    try {
      final imagePath = await localDataSource.pickImageFromGallery();
      return Right(imagePath);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> pickImageFromCamera() async {
    try {
      final imagePath = await localDataSource.pickImageFromCamera();
      return Right(imagePath);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> cropImage(String imagePath) async {
    try {
      final croppedPath = await localDataSource.cropImage(imagePath);
      return Right(croppedPath);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage({
    required String imagePath,
    required String folder,
  }) async {
    try {
      // Verificar que el archivo existe
      final file = File(imagePath);
      if (!await file.exists()) {
        throw const ServerException('El archivo de imagen no existe');
      }

      // Crear referencia en Firebase Storage
      final storage = FirebaseStorage.instance;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final ref = storage.ref().child('$folder/$fileName');

      // Subir archivo
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      // Obtener URL de descarga
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return Right(downloadUrl);
    } on FirebaseException catch (e) {
      return Left(ServerFailure('Error de Firebase: ${e.message}'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String imageUrl) async {
    try {
      // Verificar que la URL sea válida
      if (imageUrl.isEmpty) {
        throw const ServerException('URL de imagen vacía');
      }

      // Crear referencia desde la URL
      final storage = FirebaseStorage.instance;
      final ref = storage.refFromURL(imageUrl);

      // Eliminar el archivo
      await ref.delete();

      return const Right(null);
    } on FirebaseException catch (e) {
      // Si el archivo no existe, consideramos que ya está eliminado
      if (e.code == 'object-not-found') {
        return const Right(null);
      }
      return Left(ServerFailure('Error de Firebase: ${e.message}'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
