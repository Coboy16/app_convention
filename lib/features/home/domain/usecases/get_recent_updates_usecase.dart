import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetRecentUpdatesUseCase {
  final DashboardRepository repository;

  GetRecentUpdatesUseCase(this.repository);

  Future<Either<Failure, List<RecentUpdateEntity>>> call(String eventId) async {
    return await repository.getRecentUpdates(eventId);
  }
}
