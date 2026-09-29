import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/network/supabase_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_customer_exists.dart';
import 'features/auth/domain/usecases/continue_as_guest.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/resend_otp.dart';
import 'features/auth/domain/usecases/send_otp.dart';
import 'features/auth/domain/usecases/verify_otp.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/projects/data/datasources/projects_remote_data_source.dart';
import 'features/projects/data/repositories/projects_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/get_project_by_id.dart';
import 'features/projects/domain/usecases/get_projects.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';

final sl = GetIt.instance;

/// Registers dependencies. Call after Supabase has been initialized
/// (see main.dart) so `Supabase.instance.client` is available.
Future<void> init() async {
  // ---- External ----
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseClientService.client);

  // ---- Auth feature ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => CheckCustomerExists(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => ResendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => ContinueAsGuest(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  sl.registerFactory(
    () => AuthBloc(
      checkCustomerExists: sl(),
      sendOtp: sl(),
      resendOtp: sl(),
      verifyOtp: sl(),
      getCurrentUser: sl(),
      continueAsGuest: sl(),
      logout: sl(),
    ),
  );

  // ---- Projects feature ----
  sl.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => GetProjectById(sl()));
  sl.registerFactory(
    () => ProjectsBloc(getProjects: sl(), getProjectById: sl()),
  );

  // TODO: register profile/units/notifications/settings dependencies here
  // as those features are implemented.
}