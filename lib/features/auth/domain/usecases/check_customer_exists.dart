import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CheckCustomerExists {
  final AuthRepository repository;
  CheckCustomerExists(this.repository);

  Future<Either<Failure, bool>> call(String phone) {
    return repository.checkCustomerExists(phone);
  }
}