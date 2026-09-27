// get_it service locator setup.
// TODO: register data sources, repositories, use cases and blocs for each
// feature once implemented. Consider switching to the `injectable` code
// generator once the dependency graph grows.
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // TODO: sl.registerFactory / registerLazySingleton calls go here.
}
