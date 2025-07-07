import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_post_entity.dart';
import '../repositories/feed_posts_repository.dart';

class ToggleFeedPostLikeUseCase {
  final FeedPostsRepository repository;

  ToggleFeedPostLikeUseCase(this.repository);

  Future<Either<Failure, FeedPostEntity>> call(String postId) async {
    return await repository.toggleLike(postId);
  }
}
