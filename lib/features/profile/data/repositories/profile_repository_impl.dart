import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    if (await connectionChecker.hasConnection) {
      try {
        final profile = await remoteDataSource.getProfile(userId);
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    String? name,
    String? bio,
    List<String>? allergies,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final profile = await remoteDataSource.updateProfile(
          userId: userId,
          name: name,
          bio: bio,
          allergies: allergies,
        );
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final imageUrl = await remoteDataSource.uploadProfileImage(
          userId: userId,
          imagePath: imagePath,
        );
        return Right(imageUrl);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfileImage({
    required String userId,
    required String imageUrl,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final profile = await remoteDataSource.updateProfileImage(
          userId: userId,
          imageUrl: imageUrl,
        );
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(String userId) async {
    if (await connectionChecker.hasConnection) {
      try {
        final posts = await remoteDataSource.getUserPosts(userId);
        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String userId,
    String? description,
    required List<String> imagePaths,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final post = await remoteDataSource.createPost(
          userId: userId,
          description: description,
          imagePaths: imagePaths,
        );
        return Right(post);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost({
    required String userId,
    required String postId,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.deletePost(userId: userId, postId: postId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadPostImages({
    required List<String> imagePaths,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final imageUrls = await remoteDataSource.uploadPostImages(imagePaths);
        return Right(imageUrls);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }
}
