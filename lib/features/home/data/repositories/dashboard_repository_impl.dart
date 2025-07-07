import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '/core/errors/exceptions.dart';
import '/core/errors/failures.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard(String eventId) async {
    if (await connectionChecker.hasConnection) {
      try {
        final dashboard = await remoteDataSource.getDashboard(eventId);
        return Right(dashboard);
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
  Future<Either<Failure, List<TodayHighlightEntity>>> getTodayHighlights(
    String eventId,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final highlights = await remoteDataSource.getTodayHighlights(eventId);
        return Right(highlights);
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
  Future<Either<Failure, List<RecentUpdateEntity>>> getRecentUpdates(
    String eventId,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final updates = await remoteDataSource.getRecentUpdates(eventId);
        return Right(updates);
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
  Future<Either<Failure, List<SurveyEntity>>> getAvailableSurveys(
    String eventId,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final surveys = await remoteDataSource.getAvailableSurveys(eventId);
        return Right(surveys);
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
  Future<Either<Failure, void>> submitSurveyResponse({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  }) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.submitSurveyResponse(
          surveyId: surveyId,
          userId: userId,
          responses: responses,
        );
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
}
