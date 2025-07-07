part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsError extends PostsState {
  final String message;

  const PostsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PostCreating extends PostsState {
  final List<PostEntity> currentPosts;

  const PostCreating({required this.currentPosts});

  @override
  List<Object> get props => [currentPosts];
}

class PostDeleting extends PostsState {
  final List<PostEntity> currentPosts;
  final String deletingPostId;

  const PostDeleting({
    required this.currentPosts,
    required this.deletingPostId,
  });

  @override
  List<Object> get props => [currentPosts, deletingPostId];
}
