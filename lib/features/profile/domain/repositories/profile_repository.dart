import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../entities/post_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);

  Future<Either<Failure, ProfileEntity>> updateProfile({
    required String userId,
    String? name,
    String? bio,
    List<String>? allergies,
  });

  Future<Either<Failure, String>> uploadProfileImage({
    required String userId,
    required String imagePath,
  });

  Future<Either<Failure, ProfileEntity>> updateProfileImage({
    required String userId,
    required String imageUrl,
  });

  Future<Either<Failure, List<PostEntity>>> getUserPosts(String userId);

  Future<Either<Failure, PostEntity>> createPost({
    required String userId,
    String? description,
    required List<String> imagePaths,
  });

  Future<Either<Failure, void>> deletePost({
    required String userId,
    required String postId,
  });

  Future<Either<Failure, List<String>>> uploadPostImages({
    required List<String> imagePaths,
  });
}
