abstract class RefreshTokenProvider {
  // сохранение refreshToken
  Future<bool> setRefreshToken(final String? refreshTokenKey);

  Future<String?> getRefreshToken();
}