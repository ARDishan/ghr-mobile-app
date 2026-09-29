import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SendOtp {
  final AuthRepository repository;
  SendOtp(this.repository);

  Future<Either<Failure, void>> call(String phone) {
    return repository.sendOtp(phone);
  }
}