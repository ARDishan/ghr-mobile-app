import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;
  GetProfile(this.repository);

  Future<Either<Failure, ProfileEntity>> call() => repository.getProfile();
}