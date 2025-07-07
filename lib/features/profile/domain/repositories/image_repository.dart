import 'package:dartz/dartz.dart';
import '/core/errors/failures.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> pickImageFromGallery();
  Future<Either<Failure, String>> pickImageFromCamera();
  Future<Either<Failure, String>> cropImage(String imagePath);
  Future<Either<Failure, String>> uploadImage({
    required String imagePath,
    required String folder, // 'profiles' or 'posts'
  });
  Future<Either<Failure, void>> deleteImage(String imageUrl);
}
