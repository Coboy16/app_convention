import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/profile_repository.dart';

class CreatePostUseCase {
  final ProfileRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, PostEntity>> call({
    required String userId,
    String? description,
    required List<String> imagePaths,
  }) async {
    return await repository.createPost(
      userId: userId,
      description: description,
      imagePaths: imagePaths,
    );
  }
}
