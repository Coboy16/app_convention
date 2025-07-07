import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:konecta/features/posts/data/datasources/feed_posts_remote_data_source.dart';

import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';
import '../../domain/entities/feed_post_entity.dart';
import '../../domain/entities/feed_comment_entity.dart';
import '../../domain/entities/feed_story_entity.dart';
import '../../domain/repositories/feed_posts_repository.dart';

class FeedPostsRepositoryImpl implements FeedPostsRepository {
  final FeedPostsRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  FeedPostsRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<FeedPostEntity>>> getAllPosts() async {
    if (await connectionChecker.hasConnection) {
      try {
        final posts = await remoteDataSource.getAllPosts();
        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, FeedPostEntity>> createPost({
    required String content,
    required List<String> imagePaths,
    required List<String> hashtags,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final post = await remoteDataSource.createPost(
          content: content,
          imagePaths: imagePaths,
          hashtags: hashtags,
        );
        return Right(post);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String postId) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.deletePost(postId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, FeedPostEntity>> toggleLike(String postId) async {
    if (await connectionChecker.hasConnection) {
      try {
        final post = await remoteDataSource.toggleLike(postId);
        return Right(post);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<FeedCommentEntity>>> getPostComments(
    String postId,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final comments = await remoteDataSource.getPostComments(postId);
        return Right(comments);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, FeedCommentEntity>> addComment({
    required String postId,
    required String content,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final comment = await remoteDataSource.addComment(
          postId: postId,
          content: content,
        );
        return Right(comment);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.deleteComment(commentId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, FeedCommentEntity>> toggleCommentLike(
    String commentId,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final comment = await remoteDataSource.toggleCommentLike(commentId);
        return Right(comment);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<FeedStoryEntity>>> getAllStories() async {
    if (await connectionChecker.hasConnection) {
      try {
        final stories = await remoteDataSource.getAllStories();
        return Right(stories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, FeedStoryEntity>> createStory({
    required String imagePath,
    required String caption,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        final story = await remoteDataSource.createStory(
          imagePath: imagePath,
          caption: caption,
        );
        return Right(story);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, void>> markStoryAsViewed(String storyId) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.markStoryAsViewed(storyId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImages(
    List<String> imagePaths,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final imageUrls = await remoteDataSource.uploadImages(imagePaths);
        return Right(imageUrls);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Error inesperado: ${e.toString()}'));
      }
    } else {
      return const Left(ConnectionFailure('No hay conexión a internet'));
    }
  }
}
