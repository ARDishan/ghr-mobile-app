import 'package:get_it/get_it.dart';
import 'package:ghr/features/projects/presentation/bloc/project_detail_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/network/supabase_client.dart';
import 'features/about/data/company_stats_repository.dart';
import 'features/about/presentation/cubit/about_cubit.dart';
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
import 'features/bookmarks/data/bookmarks_local_data_source.dart';
import 'features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'features/my_units/data/datasources/my_units_remote_data_source.dart';
import 'features/my_units/data/repositories/my_units_repository_impl.dart';
import 'features/my_units/domain/repositories/my_units_repository.dart';
import 'features/my_units/domain/usecases/get_my_units.dart';
import 'features/my_units/presentation/bloc/my_units_bloc.dart';
import 'features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/notifications_usecases.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'features/profile/data/datasources/profile_remote_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/profile_usecases.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/projects/data/datasources/projects_remote_data_source.dart';
import 'features/projects/data/repositories/projects_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/get_project_by_id.dart';
import 'features/projects/domain/usecases/get_projects.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/units/data/datasources/units_remote_data_source.dart';
import 'features/units/data/repositories/unit_repository_impl.dart';
import 'features/units/domain/repositories/unit_repository.dart';
import 'features/units/domain/usecases/get_units_by_project.dart';
import 'features/units/presentation/bloc/units_bloc.dart';

final sl = GetIt.instance;

/// Registers dependencies. Call after Supabase has been initialized
/// (see main.dart) so `Supabase.instance.client` is available.
Future<void> init() async {
  // ---- External ----
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseClientService.client);
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ---- Auth feature ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
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
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProjects(sl()));
  sl.registerLazySingleton(() => GetProjectById(sl()));
  sl.registerFactory(() => ProjectsBloc(getProjects: sl()));
  sl.registerFactory(() => ProjectDetailBloc(getProjectById: sl()));

  // ---- Units feature ----
  sl.registerLazySingleton<UnitsRemoteDataSource>(
    () => UnitsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UnitRepository>(() => UnitRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetUnitsByProject(sl()));
  sl.registerFactory(() => UnitsBloc(getUnitsByProject: sl()));

  // ---- My units (customer balances) ----
  sl.registerLazySingleton<MyUnitsRemoteDataSource>(
    () => MyUnitsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MyUnitsRepository>(() => MyUnitsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMyUnits(sl()));
  sl.registerFactory(() => MyUnitsBloc(getMyUnits: sl()));

  // ---- Profile ----
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerFactory(() => ProfileBloc(getProfile: sl()));

  // ---- Notifications ----
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationsRead(sl()));
  sl.registerFactory(
    () => NotificationsBloc(getNotifications: sl(), markNotificationsRead: sl()),
  );

  // ---- Bookmarks (device-local) ----
  sl.registerLazySingleton(() => BookmarksLocalDataSource(sl()));
  sl.registerLazySingleton(() => BookmarksCubit(sl()));

  // ---- About ----
  sl.registerLazySingleton(() => CompanyStatsRepository(sl()));
  sl.registerFactory(() => AboutCubit(sl()));

  // TODO: settings has no dependencies yet.
}