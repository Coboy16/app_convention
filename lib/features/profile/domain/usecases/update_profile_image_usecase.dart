import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImageUseCase {
  final ProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call({
    required String userId,
    required String imagePath,
  }) async {
    // Primero subir la imagen
    final uploadResult = await repository.uploadProfileImage(
      userId: userId,
      imagePath: imagePath,
    );

    return uploadResult.fold((failure) => Left(failure), (imageUrl) async {
      // Luego actualizar el perfil con la nueva URL
      return await repository.updateProfileImage(
        userId: userId,
        imageUrl: imageUrl,
      );
    });
  }
}
