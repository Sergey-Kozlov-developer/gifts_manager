import 'package:shared_preferences/shared_preferences.dart';

// для сохранения токена
class SharedPreferenceData {
  static const _tokenKey = "token_key";
  static const _refreshTokenKey = "refresh_token_key";
  static const _userKey = "user_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() =>
      _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setToken(final String? token) =>
      _setItem(key: _tokenKey, item: token);

  Future<String?> getToken() => _getItem(_tokenKey);

  // сохранение refreshToken
  Future<bool> setRefreshToken(final String? refreshTokenKey) =>
      _setItem(key: _refreshTokenKey, item: refreshTokenKey);

  Future<String?> getRefreshToken() => _getItem(_refreshTokenKey);

  // сохранение user, setUser and getUser
  Future<bool> setUser(final String? user) =>
      _setItem(key: _userKey, item: user);

  Future<String?> getUser() => _getItem(_userKey);

  Future<bool> _setItem({
    required final String key,
    required final String? item,
  }) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String?> _getItem(
    final String key,
  ) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}
