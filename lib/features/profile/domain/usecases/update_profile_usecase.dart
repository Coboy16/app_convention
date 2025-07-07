import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call({
    required String userId,
    String? name,
    String? bio,
    List<String>? allergies,
  }) async {
    return await repository.updateProfile(
      userId: userId,
      name: name,
      bio: bio,
      allergies: allergies,
    );
  }
}
