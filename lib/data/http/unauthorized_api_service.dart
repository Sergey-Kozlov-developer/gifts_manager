import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/create_account_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';

class UnauthorizedApiService {
  final _dio = DioProvider().createDio();

  static UnauthorizedApiService? _instance;

  factory UnauthorizedApiService.getInstance() =>
      _instance ??= UnauthorizedApiService._internal();

  UnauthorizedApiService._internal();
  // метод регистрации
  Future<UserWithTokensDto?> register({
    required final String email,
    required final String password,
    required final String name,
    required final String avatarUrl,
  }) async {
    final requestBody = CreateAccountRequestDto(
      email: email,
      password: password,
      name: name,
      avatarUrl: avatarUrl,
    );
    try {
      final response = await _dio.post(
        '/auth/create',
        data: requestBody.toJson(),
      );
      // конвертация из одного типа в другой
      final userWithTokens = UserWithTokensDto.fromJson(response.data);
      return userWithTokens;
    } catch (e) {
      return null;
    }
  }
}
