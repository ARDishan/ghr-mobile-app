import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResendOtp {
  final AuthRepository repository;
  ResendOtp(this.repository);

  Future<Either<Failure, void>> call(String phone) {
    return repository.resendOtp(phone);
  }
}