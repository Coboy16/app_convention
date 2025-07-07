import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/feed_comment_entity.dart';
import '../repositories/feed_posts_repository.dart';

class GetFeedPostCommentsUseCase {
  final FeedPostsRepository repository;

  GetFeedPostCommentsUseCase(this.repository);

  Future<Either<Failure, List<FeedCommentEntity>>> call(String postId) async {
    return await repository.getPostComments(postId);
  }
}

class AddFeedCommentUseCase {
  final FeedPostsRepository repository;

  AddFeedCommentUseCase(this.repository);

  Future<Either<Failure, FeedCommentEntity>> call({
    required String postId,
    required String content,
  }) async {
    return await repository.addComment(postId: postId, content: content);
  }
}

class DeleteFeedCommentUseCase {
  final FeedPostsRepository repository;

  DeleteFeedCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(String commentId) async {
    return await repository.deleteComment(commentId);
  }
}

class ToggleFeedCommentLikeUseCase {
  final FeedPostsRepository repository;

  ToggleFeedCommentLikeUseCase(this.repository);

  Future<Either<Failure, FeedCommentEntity>> call(String commentId) async {
    return await repository.toggleCommentLike(commentId);
  }
}
