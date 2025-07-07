import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/features/posts/domain/domain.dart';

part 'feed_posts_event.dart';
part 'feed_posts_state.dart';

class FeedPostsBloc extends Bloc<FeedPostsEvent, FeedPostsState> {
  final GetAllFeedPostsUseCase getAllPostsUseCase;
  final CreateFeedPostUseCase createPostUseCase;
  final ToggleFeedPostLikeUseCase toggleLikeUseCase;
  final GetFeedPostCommentsUseCase getCommentsUseCase;
  final AddFeedCommentUseCase addCommentUseCase;
  final ToggleFeedCommentLikeUseCase toggleCommentLikeUseCase;
  final GetAllFeedStoriesUseCase getAllStoriesUseCase;
  final CreateFeedStoryUseCase createStoryUseCase;
  final MarkFeedStoryAsViewedUseCase markStoryAsViewedUseCase;

  FeedPostsBloc({
    required this.getAllPostsUseCase,
    required this.createPostUseCase,
    required this.toggleLikeUseCase,
    required this.getCommentsUseCase,
    required this.addCommentUseCase,
    required this.toggleCommentLikeUseCase,
    required this.getAllStoriesUseCase,
    required this.createStoryUseCase,
    required this.markStoryAsViewedUseCase,
  }) : super(FeedPostsInitial()) {
    on<FeedPostsLoadRequested>(_onFeedPostsLoadRequested);
    on<FeedPostsRefreshRequested>(_onFeedPostsRefreshRequested);
    on<FeedPostCreateRequested>(_onFeedPostCreateRequested);
    on<FeedPostLikeToggled>(_onFeedPostLikeToggled);
    on<FeedPostCommentsLoadRequested>(_onFeedPostCommentsLoadRequested);
    on<FeedCommentAddRequested>(_onFeedCommentAddRequested);
    on<FeedCommentLikeToggled>(_onFeedCommentLikeToggled);
    on<FeedStoriesLoadRequested>(_onFeedStoriesLoadRequested);
    on<FeedStoryCreateRequested>(_onFeedStoryCreateRequested);
    on<FeedStoryViewRequested>(_onFeedStoryViewRequested);

    debugPrint('🟢 FeedPostsBloc inicializado');
  }

  Future<void> _onFeedPostsLoadRequested(
    FeedPostsLoadRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedPostsLoadRequested');
    emit(FeedPostsLoading());

    final postsResult = await getAllPostsUseCase();
    final storiesResult = await getAllStoriesUseCase();

    postsResult.fold(
      (failure) {
        debugPrint('❌ Error al cargar posts: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (posts) {
        storiesResult.fold(
          (failure) {
            debugPrint('❌ Error al cargar historias: ${failure.message}');
            emit(FeedPostsLoaded(posts: posts, stories: const []));
          },
          (stories) {
            debugPrint(
              '✅ Feed cargado: ${posts.length} posts, ${stories.length} historias',
            );
            emit(FeedPostsLoaded(posts: posts, stories: stories));
          },
        );
      },
    );
  }

  Future<void> _onFeedPostsRefreshRequested(
    FeedPostsRefreshRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedPostsRefreshRequested');

    final postsResult = await getAllPostsUseCase();
    final storiesResult = await getAllStoriesUseCase();

    postsResult.fold(
      (failure) {
        debugPrint('❌ Error al refrescar posts: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (posts) {
        storiesResult.fold(
          (failure) {
            debugPrint('❌ Error al refrescar historias: ${failure.message}');
            emit(FeedPostsLoaded(posts: posts, stories: const []));
          },
          (stories) {
            debugPrint(
              '✅ Feed refrescado: ${posts.length} posts, ${stories.length} historias',
            );
            emit(FeedPostsLoaded(posts: posts, stories: stories));
          },
        );
      },
    );
  }

  Future<void> _onFeedPostCreateRequested(
    FeedPostCreateRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedPostCreateRequested');
    debugPrint('📋 Contenido: ${event.content}');
    debugPrint('📸 Imágenes: ${event.imagePaths.length}');
    debugPrint('🏷️ Hashtags: ${event.hashtags}');

    final currentState = state;
    if (currentState is FeedPostsLoaded) {
      emit(
        FeedPostCreating(
          currentPosts: currentState.posts,
          currentStories: currentState.stories,
        ),
      );

      final result = await createPostUseCase(
        content: event.content,
        imagePaths: event.imagePaths,
        hashtags: event.hashtags,
      );

      result.fold(
        (failure) {
          debugPrint('❌ Error al crear post: ${failure.message}');
          emit(FeedPostsError(message: failure.message));
        },
        (newPost) {
          debugPrint('✅ Post creado exitosamente: ${newPost.id}');
          final updatedPosts = [newPost, ...currentState.posts];
          emit(
            FeedPostsLoaded(posts: updatedPosts, stories: currentState.stories),
          );
        },
      );
    } else {
      debugPrint('❌ Estado actual no es FeedPostsLoaded');
      emit(
        const FeedPostsError(
          message: 'No se pueden crear posts sin cargar el feed primero',
        ),
      );
    }
  }

  Future<void> _onFeedPostLikeToggled(
    FeedPostLikeToggled event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedPostLikeToggled para post: ${event.postId}');

    final result = await toggleLikeUseCase(event.postId);

    result.fold(
      (failure) {
        debugPrint('❌ Error al toggle like: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (updatedPost) {
        debugPrint('✅ Like actualizado: ${updatedPost.isLikedByCurrentUser}');

        final currentState = state;
        if (currentState is FeedPostsLoaded) {
          final updatedPosts = currentState.posts.map((post) {
            return post.id == updatedPost.id ? updatedPost : post;
          }).toList();

          emit(
            FeedPostsLoaded(posts: updatedPosts, stories: currentState.stories),
          );
        }
      },
    );
  }

  Future<void> _onFeedPostCommentsLoadRequested(
    FeedPostCommentsLoadRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedPostCommentsLoadRequested para post: ${event.postId}');

    emit(FeedCommentsLoading(postId: event.postId));

    final result = await getCommentsUseCase(event.postId);

    result.fold(
      (failure) {
        debugPrint('❌ Error al cargar comentarios: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (comments) {
        debugPrint('✅ Comentarios cargados: ${comments.length}');
        emit(FeedCommentsLoaded(postId: event.postId, comments: comments));
      },
    );
  }

  Future<void> _onFeedCommentAddRequested(
    FeedCommentAddRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedCommentAddRequested para post: ${event.postId}');

    final result = await addCommentUseCase(
      postId: event.postId,
      content: event.content,
    );

    result.fold(
      (failure) {
        debugPrint('❌ Error al agregar comentario: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (newComment) {
        debugPrint('✅ Comentario agregado: ${newComment.id}');
        emit(FeedCommentAdded(comment: newComment));

        // Refrescar el feed para actualizar el contador de comentarios
        add(FeedPostsRefreshRequested());
      },
    );
  }

  Future<void> _onFeedCommentLikeToggled(
    FeedCommentLikeToggled event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedCommentLikeToggled para comentario: ${event.commentId}');

    final result = await toggleCommentLikeUseCase(event.commentId);

    result.fold(
      (failure) {
        debugPrint('❌ Error al toggle like del comentario: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (updatedComment) {
        debugPrint(
          '✅ Like del comentario actualizado: ${updatedComment.isLikedByCurrentUser}',
        );
        emit(FeedCommentLikeUpdated(comment: updatedComment));
      },
    );
  }

  Future<void> _onFeedStoriesLoadRequested(
    FeedStoriesLoadRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedStoriesLoadRequested');

    final result = await getAllStoriesUseCase();

    result.fold(
      (failure) {
        debugPrint('❌ Error al cargar historias: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (stories) {
        debugPrint('✅ Historias cargadas: ${stories.length}');
        emit(FeedStoriesLoaded(stories: stories));
      },
    );
  }

  Future<void> _onFeedStoryCreateRequested(
    FeedStoryCreateRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedStoryCreateRequested');

    emit(FeedStoryCreating());

    final result = await createStoryUseCase(
      imagePath: event.imagePath,
      caption: event.caption,
    );

    result.fold(
      (failure) {
        debugPrint('❌ Error al crear historia: ${failure.message}');
        emit(FeedPostsError(message: failure.message));
      },
      (newStory) {
        debugPrint('✅ Historia creada: ${newStory.id}');
        emit(FeedStoryCreated(story: newStory));

        // Refrescar el feed
        add(FeedPostsRefreshRequested());
      },
    );
  }

  Future<void> _onFeedStoryViewRequested(
    FeedStoryViewRequested event,
    Emitter<FeedPostsState> emit,
  ) async {
    debugPrint('🔄 FeedStoryViewRequested para historia: ${event.storyId}');

    // IMPORTANTE: No cambiar el estado, solo actualizar en segundo plano
    final currentState = state;

    // Solo proceder si tenemos un estado válido
    if (currentState is! FeedPostsLoaded) {
      debugPrint(
        '⚠️ Estado actual no es FeedPostsLoaded, saltando vista de historia',
      );
      return;
    }

    try {
      final result = await markStoryAsViewedUseCase(event.storyId);

      result.fold(
        (failure) {
          debugPrint(
            '❌ Error al marcar historia como vista: ${failure.message}',
          );
        },
        (_) {
          debugPrint('✅ Historia marcada como vista: ${event.storyId}');

          final updatedStories = currentState.stories.map((story) {
            if (story.id == event.storyId) {
              return story.copyWith(isViewedByCurrentUser: true);
            }
            return story;
          }).toList();

          if (mounted) {
            emit(
              FeedPostsLoaded(
                posts: currentState.posts,
                stories: updatedStories,
              ),
            );
            debugPrint(
              '🔄 Estado actualizado localmente para historia: ${event.storyId}',
            );
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Excepción al marcar historia como vista: $e');
      // No emitir error
    }
  }

  bool get mounted {
    try {
      // Verificar si el estado aún es válido
      return state is FeedPostsLoaded;
    } catch (e) {
      return false;
    }
  }

  // Métodos helper para uso externo
  void loadFeed() => add(FeedPostsLoadRequested());
  void refreshFeed() => add(FeedPostsRefreshRequested());
  void createPost(
    String content,
    List<String> imagePaths,
    List<String> hashtags,
  ) => add(
    FeedPostCreateRequested(
      content: content,
      imagePaths: imagePaths,
      hashtags: hashtags,
    ),
  );
  void togglePostLike(String postId) =>
      add(FeedPostLikeToggled(postId: postId));
  void loadComments(String postId) =>
      add(FeedPostCommentsLoadRequested(postId: postId));
  void addComment(String postId, String content) =>
      add(FeedCommentAddRequested(postId: postId, content: content));
  void toggleCommentLike(String commentId) =>
      add(FeedCommentLikeToggled(commentId: commentId));
  void loadStories() => add(FeedStoriesLoadRequested());
  void createStory(String imagePath, String caption) =>
      add(FeedStoryCreateRequested(imagePath: imagePath, caption: caption));
  void viewStory(String storyId) =>
      add(FeedStoryViewRequested(storyId: storyId));
}
