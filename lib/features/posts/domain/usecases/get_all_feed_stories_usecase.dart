import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_story_entity.dart';
import '../repositories/feed_posts_repository.dart';

class GetAllFeedStoriesUseCase {
  final FeedPostsRepository repository;

  GetAllFeedStoriesUseCase(this.repository);

  Future<Either<Failure, List<FeedStoryEntity>>> call() async {
    return await repository.getAllStories();
  }
}

class CreateFeedStoryUseCase {
  final FeedPostsRepository repository;

  CreateFeedStoryUseCase(this.repository);

  Future<Either<Failure, FeedStoryEntity>> call({
    required String imagePath,
    required String caption,
  }) async {
    return await repository.createStory(imagePath: imagePath, caption: caption);
  }
}

class MarkFeedStoryAsViewedUseCase {
  final FeedPostsRepository repository;

  MarkFeedStoryAsViewedUseCase(this.repository);

  Future<Either<Failure, void>> call(String storyId) async {
    return await repository.markStoryAsViewed(storyId);
  }
}
