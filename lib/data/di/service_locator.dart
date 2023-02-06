import 'package:get_it/get_it.dart';
import 'package:gifts_manager/data/repository/refresh_token_provider.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerLazySingleton(() => SharedPreferenceData());
  sl.registerLazySingleton<RefreshTokenProvider>(
    () => sl.get<SharedPreferenceData>(),
  );
}
