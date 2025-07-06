part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;
  final List<StoryModel> stories;

  const FeedLoaded({required this.posts, required this.stories});

  @override
  List<Object> get props => [posts, stories];
}

class FeedError extends FeedState {
  final String message;

  const FeedError({required this.message});

  @override
  List<Object> get props => [message];
}

class PostLikeUpdated extends FeedState {
  final String postId;
  final bool isLiked;
  final int likesCount;

  const PostLikeUpdated({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  List<Object> get props => [postId, isLiked, likesCount];
}

class CommentsLoaded extends FeedState {
  final String postId;
  final List<CommentModel> comments;

  const CommentsLoaded({required this.postId, required this.comments});

  @override
  List<Object> get props => [postId, comments];
}

class CommentAdded extends FeedState {
  final CommentModel comment;

  const CommentAdded({required this.comment});

  @override
  List<Object> get props => [comment];
}

class StoryViewed extends FeedState {
  final String storyId;

  const StoryViewed({required this.storyId});

  @override
  List<Object> get props => [storyId];
}
