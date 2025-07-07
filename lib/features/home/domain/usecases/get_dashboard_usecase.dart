import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call(String eventId) async {
    return await repository.getDashboard(eventId);
  }
}
