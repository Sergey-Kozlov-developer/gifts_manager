import 'dart:convert';

import 'package:gifts_manager/data/http/model/user_dto.dart';
import 'package:gifts_manager/data/repository/base/reactive_repository.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';

// для получения и конвертации пользователя данных в стринг
class UserRepository extends ReactiveRepository<UserDto> {
  static UserRepository? _instance;

  factory UserRepository.getInstance() => _instance ??=
      UserRepository._internal(SharedPreferenceData.getInstance());

  UserRepository._internal(this._spData);

  final SharedPreferenceData _spData;

  @override
  UserDto convertFromString(String rawItem) =>
      UserDto.fromJson(json.decode(rawItem));

  @override
  String convertToString(UserDto item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _spData.getUser();

  @override
  Future<bool> saveRawData(String? item) => _spData.setUser(item);
}
