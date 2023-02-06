import 'package:gifts_manager/data/di/service_locator.dart';
import 'package:gifts_manager/data/repository/base/reactive_repository.dart';
import 'package:gifts_manager/data/repository/refresh_token_provider.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';

// обновление токена
class RefreshTokenRepository extends ReactiveRepository<String> {
  static RefreshTokenRepository? _instance;

  factory RefreshTokenRepository.getInstance() => _instance ??=
      RefreshTokenRepository._internal(sl.get<RefreshTokenProvider>());

  RefreshTokenRepository._internal(this._refreshTokenProvider);

  final RefreshTokenProvider _refreshTokenProvider;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _refreshTokenProvider.getRefreshToken();

  @override
  Future<bool> saveRawData(String? item) => _refreshTokenProvider.setRefreshToken(item);
}
