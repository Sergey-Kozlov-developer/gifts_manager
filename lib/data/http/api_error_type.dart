import 'dart:ffi';

enum ApiErrorType {
  // возможные ошибки
  incorrectPassword(21),
  notFound(103),
  missingParams("E_MISSING_OR_INVALID_PARAMS"),
  unknow('unknow');

  const ApiErrorType(this.code);

  final dynamic code;

  // метод который позволяет вернуть апи
  static ApiErrorType getByCode(final dynamic code) {
    return ApiErrorType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => ApiErrorType.unknow,
    );
  }
}
