import 'package:dartz/dartz.dart';
import '/core/errors/errors.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
  }
}
