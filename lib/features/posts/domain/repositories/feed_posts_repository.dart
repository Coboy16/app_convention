import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_post_entity.dart';
import '../entities/feed_comment_entity.dart';
import '../entities/feed_story_entity.dart';

abstract class FeedPostsRepository {
  // Posts
  Future<Either<Failure, List<FeedPostEntity>>> getAllPosts();
  Future<Either<Failure, FeedPostEntity>> createPost({
    required String content,
    required List<String> imagePaths,
    required List<String> hashtags,
  });
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, FeedPostEntity>> toggleLike(String postId);

  // Comments
  Future<Either<Failure, List<FeedCommentEntity>>> getPostComments(
    String postId,
  );
  Future<Either<Failure, FeedCommentEntity>> addComment({
    required String postId,
    required String content,
  });
  Future<Either<Failure, void>> deleteComment(String commentId);
  Future<Either<Failure, FeedCommentEntity>> toggleCommentLike(
    String commentId,
  );

  // Stories
  Future<Either<Failure, List<FeedStoryEntity>>> getAllStories();
  Future<Either<Failure, FeedStoryEntity>> createStory({
    required String imagePath,
    required String caption,
  });
  Future<Either<Failure, void>> markStoryAsViewed(String storyId);

  // Utils
  Future<Either<Failure, List<String>>> uploadImages(List<String> imagePaths);
}
