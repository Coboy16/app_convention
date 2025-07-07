import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/features/profile/domain/domain.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetUserPostsUseCase getUserPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;

  PostsBloc({
    required this.getUserPostsUseCase,
    required this.createPostUseCase,
    required this.deletePostUseCase,
  }) : super(PostsInitial()) {
    on<PostsLoadRequested>(_onPostsLoadRequested);
    on<PostCreateRequested>(_onPostCreateRequested);
    on<PostDeleteRequested>(_onPostDeleteRequested);
    on<PostsRefreshRequested>(_onPostsRefreshRequested);
  }

  Future<void> _onPostsLoadRequested(
    PostsLoadRequested event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());

    final result = await getUserPostsUseCase(event.userId);

    result.fold(
      (failure) => emit(PostsError(message: failure.message)),
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }

  Future<void> _onPostCreateRequested(
    PostCreateRequested event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is PostsLoaded) {
      emit(PostCreating(currentPosts: currentState.posts));

      final result = await createPostUseCase(
        userId: event.userId,
        description: event.description,
        imagePaths: event.imagePaths,
      );

      result.fold((failure) => emit(PostsError(message: failure.message)), (
        newPost,
      ) {
        final updatedPosts = [newPost, ...currentState.posts];
        emit(PostsLoaded(posts: updatedPosts));
      });
    }
  }

  Future<void> _onPostDeleteRequested(
    PostDeleteRequested event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is PostsLoaded) {
      emit(
        PostDeleting(
          currentPosts: currentState.posts,
          deletingPostId: event.postId,
        ),
      );

      final result = await deletePostUseCase(
        userId: event.userId,
        postId: event.postId,
      );

      result.fold((failure) => emit(PostsError(message: failure.message)), (_) {
        final updatedPosts = currentState.posts
            .where((post) => post.id != event.postId)
            .toList();
        emit(PostsLoaded(posts: updatedPosts));
      });
    }
  }

  Future<void> _onPostsRefreshRequested(
    PostsRefreshRequested event,
    Emitter<PostsState> emit,
  ) async {
    final result = await getUserPostsUseCase(event.userId);

    result.fold(
      (failure) => emit(PostsError(message: failure.message)),
      (posts) => emit(PostsLoaded(posts: posts)),
    );
  }
}
