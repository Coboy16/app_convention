import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_post_entity.dart';
import '../repositories/feed_posts_repository.dart';

class GetAllFeedPostsUseCase {
  final FeedPostsRepository repository;

  GetAllFeedPostsUseCase(this.repository);

  Future<Either<Failure, List<FeedPostEntity>>> call() async {
    return await repository.getAllPosts();
  }
}
