import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetTodayHighlightsUseCase {
  final DashboardRepository repository;

  GetTodayHighlightsUseCase(this.repository);

  Future<Either<Failure, List<TodayHighlightEntity>>> call(
    String eventId,
  ) async {
    return await repository.getTodayHighlights(eventId);
  }
}
