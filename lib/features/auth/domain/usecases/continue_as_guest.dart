import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class ContinueAsGuest {
  final AuthRepository repository;
  ContinueAsGuest(this.repository);

  Future<Either<Failure, AuthUserEntity>> call() {
    return repository.continueAsGuest();
  }
}