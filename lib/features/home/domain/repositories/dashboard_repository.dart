import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard(String eventId);

  Future<Either<Failure, List<TodayHighlightEntity>>> getTodayHighlights(
    String eventId,
  );

  Future<Either<Failure, List<RecentUpdateEntity>>> getRecentUpdates(
    String eventId,
  );

  Future<Either<Failure, List<SurveyEntity>>> getAvailableSurveys(
    String eventId,
  );

  Future<Either<Failure, void>> submitSurveyResponse({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  });
}
