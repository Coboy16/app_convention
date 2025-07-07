part of 'feed_posts_bloc.dart';

abstract class FeedPostsState extends Equatable {
  const FeedPostsState();

  @override
  List<Object?> get props => [];
}

class FeedPostsInitial extends FeedPostsState {}

class FeedPostsLoading extends FeedPostsState {}

class FeedPostsLoaded extends FeedPostsState {
  final List<FeedPostEntity> posts;
  final List<FeedStoryEntity> stories;

  const FeedPostsLoaded({required this.posts, required this.stories});

  @override
  List<Object> get props => [posts, stories];
}

class FeedPostsError extends FeedPostsState {
  final String message;

  const FeedPostsError({required this.message});

  @override
  List<Object> get props => [message];
}

class FeedPostCreating extends FeedPostsState {
  final List<FeedPostEntity> currentPosts;
  final List<FeedStoryEntity> currentStories;

  const FeedPostCreating({
    required this.currentPosts,
    required this.currentStories,
  });

  @override
  List<Object> get props => [currentPosts, currentStories];
}

class FeedCommentsLoading extends FeedPostsState {
  final String postId;

  const FeedCommentsLoading({required this.postId});

  @override
  List<Object> get props => [postId];
}

class FeedCommentsLoaded extends FeedPostsState {
  final String postId;
  final List<FeedCommentEntity> comments;

  const FeedCommentsLoaded({required this.postId, required this.comments});

  @override
  List<Object> get props => [postId, comments];
}

class FeedCommentAdded extends FeedPostsState {
  final FeedCommentEntity comment;

  const FeedCommentAdded({required this.comment});

  @override
  List<Object> get props => [comment];
}

class FeedCommentLikeUpdated extends FeedPostsState {
  final FeedCommentEntity comment;

  const FeedCommentLikeUpdated({required this.comment});

  @override
  List<Object> get props => [comment];
}

class FeedStoriesLoaded extends FeedPostsState {
  final List<FeedStoryEntity> stories;

  const FeedStoriesLoaded({required this.stories});

  @override
  List<Object> get props => [stories];
}

class FeedStoryCreating extends FeedPostsState {}

class FeedStoryCreated extends FeedPostsState {
  final FeedStoryEntity story;

  const FeedStoryCreated({required this.story});

  @override
  List<Object> get props => [story];
}

class FeedStoryViewed extends FeedPostsState {
  final String storyId;

  const FeedStoryViewed({required this.storyId});

  @override
  List<Object> get props => [storyId];
}
