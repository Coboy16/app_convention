import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';

import '../repositories/image_repository.dart';

class PickImageUseCase {
  final ImageRepository repository;

  PickImageUseCase(this.repository);

  Future<Either<Failure, String>> fromGallery() async {
    return await repository.pickImageFromGallery();
  }

  Future<Either<Failure, String>> fromCamera() async {
    return await repository.pickImageFromCamera();
  }

  Future<Either<Failure, String>> cropImage(String imagePath) async {
    return await repository.cropImage(imagePath);
  }
}
