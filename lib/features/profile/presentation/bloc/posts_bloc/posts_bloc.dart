import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

    debugPrint('🟢 PostsBloc inicializado');
  }

  Future<void> _onPostsLoadRequested(
    PostsLoadRequested event,
    Emitter<PostsState> emit,
  ) async {
    debugPrint('🔄 PostsLoadRequested para userId: ${event.userId}');
    emit(PostsLoading());

    final result = await getUserPostsUseCase(event.userId);

    result.fold(
      (failure) {
        debugPrint('❌ Error al cargar posts: ${failure.message}');
        emit(PostsError(message: failure.message));
      },
      (posts) {
        debugPrint('✅ Posts cargados exitosamente: ${posts.length} posts');
        for (int i = 0; i < posts.length; i++) {
          debugPrint(
            '   Post $i: ${posts[i].id} - ${posts[i].imageUrls.length} imágenes',
          );
        }
        emit(PostsLoaded(posts: posts));
      },
    );
  }

  Future<void> _onPostCreateRequested(
    PostCreateRequested event,
    Emitter<PostsState> emit,
  ) async {
    debugPrint('🔄 PostCreateRequested para userId: ${event.userId}');
    debugPrint('📋 Datos del post:');
    debugPrint('   - userId: ${event.userId}');
    debugPrint('   - description: ${event.description}');
    debugPrint('   - imagePaths: ${event.imagePaths.length} imágenes');

    for (int i = 0; i < event.imagePaths.length; i++) {
      debugPrint('   - Imagen $i: ${event.imagePaths[i]}');
    }

    final currentState = state;
    if (currentState is PostsLoaded) {
      debugPrint(
        '📤 Estado actual: ${currentState.posts.length} posts existentes',
      );
      emit(PostCreating(currentPosts: currentState.posts));

      final result = await createPostUseCase(
        userId: event.userId,
        description: event.description,
        imagePaths: event.imagePaths,
      );

      result.fold(
        (failure) {
          debugPrint('❌ Error al crear post: ${failure.message}');
          emit(PostsError(message: failure.message));
        },
        (newPost) {
          debugPrint('✅ Post creado exitosamente:');
          debugPrint('   - Post ID: ${newPost.id}');
          debugPrint('   - URLs de imágenes: ${newPost.imageUrls.length}');
          for (int i = 0; i < newPost.imageUrls.length; i++) {
            debugPrint('   - URL $i: ${newPost.imageUrls[i]}');
          }

          final updatedPosts = [newPost, ...currentState.posts];
          debugPrint('📊 Total posts después de crear: ${updatedPosts.length}');
          emit(PostsLoaded(posts: updatedPosts));
        },
      );
    } else {
      debugPrint(
        '❌ Estado actual no es PostsLoaded: ${currentState.runtimeType}',
      );
      emit(
        const PostsError(
          message:
              'No se pueden crear posts sin cargar posts existentes primero',
        ),
      );
    }
  }

  Future<void> _onPostDeleteRequested(
    PostDeleteRequested event,
    Emitter<PostsState> emit,
  ) async {
    debugPrint('🔄 PostDeleteRequested para postId: ${event.postId}');

    final currentState = state;
    if (currentState is PostsLoaded) {
      debugPrint(
        '🗑️ Eliminando post del estado actual (${currentState.posts.length} posts)',
      );
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

      result.fold(
        (failure) {
          debugPrint('❌ Error al eliminar post: ${failure.message}');
          emit(PostsError(message: failure.message));
        },
        (_) {
          final updatedPosts = currentState.posts
              .where((post) => post.id != event.postId)
              .toList();
          debugPrint(
            '✅ Post eliminado. Posts restantes: ${updatedPosts.length}',
          );
          emit(PostsLoaded(posts: updatedPosts));
        },
      );
    } else {
      debugPrint(
        '❌ Estado actual no es PostsLoaded para eliminar: ${currentState.runtimeType}',
      );
    }
  }

  Future<void> _onPostsRefreshRequested(
    PostsRefreshRequested event,
    Emitter<PostsState> emit,
  ) async {
    debugPrint('🔄 PostsRefreshRequested para userId: ${event.userId}');

    final result = await getUserPostsUseCase(event.userId);

    result.fold(
      (failure) {
        debugPrint('❌ Error al refrescar posts: ${failure.message}');
        emit(PostsError(message: failure.message));
      },
      (posts) {
        debugPrint('✅ Posts refrescados: ${posts.length} posts');
        emit(PostsLoaded(posts: posts));
      },
    );
  }
}
