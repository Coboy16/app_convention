import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class DeletePostUseCase {
  final ProfileRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String postId,
  }) async {
    return await repository.deletePost(userId: userId, postId: postId);
  }
}
