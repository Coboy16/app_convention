part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedLoadRequested extends FeedEvent {}

class FeedRefreshRequested extends FeedEvent {}

class PostLikeToggled extends FeedEvent {
  final String postId;

  const PostLikeToggled({required this.postId});

  @override
  List<Object> get props => [postId];
}

class CommentsLoadRequested extends FeedEvent {
  final String postId;

  const CommentsLoadRequested({required this.postId});

  @override
  List<Object> get props => [postId];
}

class CommentAddRequested extends FeedEvent {
  final String postId;
  final String content;

  const CommentAddRequested({required this.postId, required this.content});

  @override
  List<Object> get props => [postId, content];
}

class StoryViewRequested extends FeedEvent {
  final String storyId;

  const StoryViewRequested({required this.storyId});

  @override
  List<Object> get props => [storyId];
}
