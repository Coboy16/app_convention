part of 'feed_posts_bloc.dart';

abstract class FeedPostsEvent extends Equatable {
  const FeedPostsEvent();

  @override
  List<Object?> get props => [];
}

class FeedPostsLoadRequested extends FeedPostsEvent {}

class FeedPostsRefreshRequested extends FeedPostsEvent {}

class FeedPostCreateRequested extends FeedPostsEvent {
  final String content;
  final List<String> imagePaths;
  final List<String> hashtags;

  const FeedPostCreateRequested({
    required this.content,
    required this.imagePaths,
    required this.hashtags,
  });

  @override
  List<Object> get props => [content, imagePaths, hashtags];
}

class FeedPostLikeToggled extends FeedPostsEvent {
  final String postId;

  const FeedPostLikeToggled({required this.postId});

  @override
  List<Object> get props => [postId];
}

class FeedPostCommentsLoadRequested extends FeedPostsEvent {
  final String postId;

  const FeedPostCommentsLoadRequested({required this.postId});

  @override
  List<Object> get props => [postId];
}

class FeedCommentAddRequested extends FeedPostsEvent {
  final String postId;
  final String content;

  const FeedCommentAddRequested({required this.postId, required this.content});

  @override
  List<Object> get props => [postId, content];
}

class FeedCommentLikeToggled extends FeedPostsEvent {
  final String commentId;

  const FeedCommentLikeToggled({required this.commentId});

  @override
  List<Object> get props => [commentId];
}

class FeedStoriesLoadRequested extends FeedPostsEvent {}

class FeedStoryCreateRequested extends FeedPostsEvent {
  final String imagePath;
  final String caption;

  const FeedStoryCreateRequested({
    required this.imagePath,
    required this.caption,
  });

  @override
  List<Object> get props => [imagePath, caption];
}

class FeedStoryViewRequested extends FeedPostsEvent {
  final String storyId;

  const FeedStoryViewRequested({required this.storyId});

  @override
  List<Object> get props => [storyId];
}
