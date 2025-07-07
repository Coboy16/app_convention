import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetAvailableSurveysUseCase {
  final DashboardRepository repository;

  GetAvailableSurveysUseCase(this.repository);

  Future<Either<Failure, List<SurveyEntity>>> call(String eventId) async {
    return await repository.getAvailableSurveys(eventId);
  }
}
