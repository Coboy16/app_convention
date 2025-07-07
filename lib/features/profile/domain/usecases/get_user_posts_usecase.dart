import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/post_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserPostsUseCase {
  final ProfileRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call(String userId) async {
    return await repository.getUserPosts(userId);
  }
}
