import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
