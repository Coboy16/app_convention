import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../repositories/dashboard_repository.dart';

class SubmitSurveyResponseUseCase {
  final DashboardRepository repository;

  SubmitSurveyResponseUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String surveyId,
    required String userId,
    required Map<String, dynamic> responses,
  }) async {
    return await repository.submitSurveyResponse(
      surveyId: surveyId,
      userId: userId,
      responses: responses,
    );
  }
}
