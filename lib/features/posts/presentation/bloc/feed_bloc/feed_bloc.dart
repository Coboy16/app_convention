import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:konecta/features/posts/data/data.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  List<PostTwoModel> _posts = [];
  List<StoryModel> _stories = [];

  FeedBloc() : super(FeedInitial()) {
    on<FeedLoadRequested>(_onFeedLoadRequested);
    on<FeedRefreshRequested>(_onFeedRefreshRequested);
    on<PostLikeToggled>(_onPostLikeToggled);
    on<CommentsLoadRequested>(_onCommentsLoadRequested);
    on<CommentAddRequested>(_onCommentAddRequested);
    on<StoryViewRequested>(_onStoryViewRequested);
  }

  Future<void> _onFeedLoadRequested(
    FeedLoadRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      emit(FeedLoading());

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 1));

      _posts = PostTwoModel.mockPosts;
      _stories = StoryModel.mockStories;

      emit(FeedLoaded(posts: _posts, stories: _stories));
    } catch (e) {
      emit(FeedError(message: 'Error al cargar el feed: ${e.toString()}'));
    }
  }

  Future<void> _onFeedRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Simular refresh
      await Future.delayed(const Duration(milliseconds: 500));

      _posts = PostTwoModel.mockPosts;
      _stories = StoryModel.mockStories;

      emit(FeedLoaded(posts: _posts, stories: _stories));
    } catch (e) {
      emit(FeedError(message: 'Error al refrescar el feed: ${e.toString()}'));
    }
  }

  Future<void> _onPostLikeToggled(
    PostLikeToggled event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == event.postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        final updatedPost = post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );

        _posts[postIndex] = updatedPost;

        emit(
          PostLikeUpdated(
            postId: event.postId,
            isLiked: updatedPost.isLiked,
            likesCount: updatedPost.likesCount,
          ),
        );

        // Volver al estado loaded
        emit(FeedLoaded(posts: _posts, stories: _stories));
      }
    } catch (e) {
      emit(FeedError(message: 'Error al actualizar like: ${e.toString()}'));
    }
  }

  Future<void> _onCommentsLoadRequested(
    CommentsLoadRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Simular carga de comentarios
      await Future.delayed(const Duration(milliseconds: 500));

      final comments = CommentModel.getMockComments(event.postId);

      emit(CommentsLoaded(postId: event.postId, comments: comments));
    } catch (e) {
      emit(FeedError(message: 'Error al cargar comentarios: ${e.toString()}'));
    }
  }

  Future<void> _onCommentAddRequested(
    CommentAddRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      // Simular agregar comentario
      await Future.delayed(const Duration(milliseconds: 300));

      final newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: event.postId,
        userId: 'current_user',
        username: 'John Doe',
        content: event.content,
        createdAt: DateTime.now(),
      );

      // Actualizar contador de comentarios en el post
      final postIndex = _posts.indexWhere((post) => post.id == event.postId);
      if (postIndex != -1) {
        final post = _posts[postIndex];
        _posts[postIndex] = post.copyWith(
          commentsCount: post.commentsCount + 1,
        );
      }

      emit(CommentAdded(comment: newComment));
      emit(FeedLoaded(posts: _posts, stories: _stories));
    } catch (e) {
      emit(FeedError(message: 'Error al agregar comentario: ${e.toString()}'));
    }
  }

  Future<void> _onStoryViewRequested(
    StoryViewRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final storyIndex = _stories.indexWhere(
        (story) => story.id == event.storyId,
      );
      if (storyIndex != -1) {
        _stories[storyIndex] = _stories[storyIndex].copyWith(isViewed: true);

        emit(StoryViewed(storyId: event.storyId));
        emit(FeedLoaded(posts: _posts, stories: _stories));
      }
    } catch (e) {
      emit(
        FeedError(
          message: 'Error al marcar historia como vista: ${e.toString()}',
        ),
      );
    }
  }

  // Métodos helper
  void loadFeed() {
    add(FeedLoadRequested());
  }

  void refreshFeed() {
    add(FeedRefreshRequested());
  }

  void togglePostLike(String postId) {
    add(PostLikeToggled(postId: postId));
  }

  void loadComments(String postId) {
    add(CommentsLoadRequested(postId: postId));
  }

  void addComment(String postId, String content) {
    add(CommentAddRequested(postId: postId, content: content));
  }

  void viewStory(String storyId) {
    add(StoryViewRequested(storyId: storyId));
  }
}
