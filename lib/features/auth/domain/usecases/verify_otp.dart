import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams {
  final String phone;
  final String otp;
  const VerifyOtpParams({required this.phone, required this.otp});
}

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<Either<Failure, AuthUserEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(phone: params.phone, otp: params.otp);
  }
}