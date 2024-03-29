import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/dio_provider.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/create_account_request_dto.dart';
import 'package:gifts_manager/data/http/model/login_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';

class UnauthorizedApiService {
  final _dio = DioProvider().createDio();

  static UnauthorizedApiService? _instance;

  factory UnauthorizedApiService.getInstance() =>
      _instance ??= UnauthorizedApiService._internal();

  UnauthorizedApiService._internal();
  // метод регистрации
  Future<Either<ApiError, UserWithTokensDto>> register({
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
      return Right(userWithTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  Future<Either<ApiError, UserWithTokensDto>> login({
    required final String email,
    required final String password,
  }) async {
    final requestBody = LoginRequestDto(
      email: email,
      password: password,
    );
    try {
      final response = await _dio.post(
        '/auth/login',
        data: requestBody.toJson(),
      );
      // конвертация из одного типа в другой
      final userWithTokens = UserWithTokensDto.fromJson(response.data);
      return Right(userWithTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  ApiError _getApiError(final dynamic e) {
    if (e is DioError) {
      if (e.type == DioErrorType.response && e.response != null) {
        try {
          final apiError = ApiError.fromJson(e.response!.data);
          return apiError;
        } catch (apiE) {
          return ApiError(code: ApiErrorType.unknow);
        }
      }
    }
    return ApiError(code: ApiErrorType.unknow);
  }
}
