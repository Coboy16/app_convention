import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_post_entity.dart';
import '../repositories/feed_posts_repository.dart';

class CreateFeedPostUseCase {
  final FeedPostsRepository repository;

  CreateFeedPostUseCase(this.repository);

  Future<Either<Failure, FeedPostEntity>> call({
    required String content,
    required List<String> imagePaths,
    required List<String> hashtags,
  }) async {
    return await repository.createPost(
      content: content,
      imagePaths: imagePaths,
      hashtags: hashtags,
    );
  }
}
