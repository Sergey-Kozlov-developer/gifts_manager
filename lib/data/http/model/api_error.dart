import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable()
class ApiError extends Equatable {
  final dynamic code;
  final String? message;
  final String? error;

  const ApiError({
    required this.code,
    this.message,
    this.error,
  });

  factory ApiError.fromJson(final Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);

  ApiErrorType get errorType => ApiErrorType.getByCode(code);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  List<Object?> get props => [code, message, error];
}
