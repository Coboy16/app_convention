part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class PostsLoadRequested extends PostsEvent {
  final String userId;

  const PostsLoadRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class PostCreateRequested extends PostsEvent {
  final String userId;
  final String? description;
  final List<String> imagePaths;

  const PostCreateRequested({
    required this.userId,
    this.description,
    required this.imagePaths,
  });

  @override
  List<Object?> get props => [userId, description, imagePaths];
}

class PostDeleteRequested extends PostsEvent {
  final String userId;
  final String postId;

  const PostDeleteRequested({required this.userId, required this.postId});

  @override
  List<Object> get props => [userId, postId];
}

class PostsRefreshRequested extends PostsEvent {
  final String userId;

  const PostsRefreshRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}
