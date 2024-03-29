import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/create_account_request_dto.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gifts_manager/data/http/unauthorized_api_service.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/data/repository/refresh_token_repository.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/data/repository/user_repository.dart';
import 'package:gifts_manager/data/storage/shared_preferences_data.dart';
import 'package:gifts_manager/presentation/registration/model/errors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  static const _defaultAvatarKey = 'test';
  static final _registrationPasswordRegexp = RegExp(r'^[a-zA-Z0-9]+$');

  static String _avatarBuilder(String key) =>
      'https://avatars.dicebear.com/api/croodles/$key.svg';

  String _avatarKey = _defaultAvatarKey;

  // информация о вводе данных email
  String _email = '';
  bool _highlightEmailError = false;
  RegistarationEmailError? _emailError = RegistarationEmailError.empty;

  // информация о вводе данных password
  String _password = '';
  bool _highlightPasswordError = false;
  RegistarationPasswordError? _passwordError = RegistarationPasswordError.empty;

  // информация о вводе данных password 2 раз
  String _passwordConfirmation = '';
  bool _highlightPasswordConfirmationError = false;
  RegistarationPasswordConfirmationError? _passwordConfirmationError =
      RegistarationPasswordConfirmationError.empty;

  // информация о вводе данных name
  String _name = '';
  bool _highlightNameError = false;
  RegistarationNameError? _nameError = RegistarationNameError.empty;

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
          avatarLink: _avatarBuilder(_defaultAvatarKey),
        )) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChange>(_onEmailChanged);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationPasswordChange>(_onPasswordChanged);
    on<RegistrationPasswordFocusLost>(_onPasswordFocusLost);
    on<RegistrationPasswordConfirmationChange>(_onPasswordConfirmationChanged);
    on<RegistrationPasswordConfirmationFocusLost>(
        _onPasswordConfirmationFocusLost);
    on<RegistrationNameChange>(_onNameChanged);
    on<RegistrationNameFocusLost>(_onNameFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  FutureOr<void> _onChangeAvatar(
    final RegistrationChangeAvatar event,
    final Emitter<RegistrationState> emit,
  ) {
    _avatarKey = Random().nextInt(1000000).toString();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailChanged(
    final RegistrationEmailChange event,
    final Emitter<RegistrationState> emit,
  ) {
    // обновление текущего знач email
    _email = event.email;
    // обновление  emailError
    _emailError = _validateEmail();
    // эмитим есть ли ошибка или нет. обновляем инфу с филдами
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
    final RegistrationEmailFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
  }

  // метод ввода пароля
  FutureOr<void> _onPasswordChanged(
    final RegistrationPasswordChange event,
    final Emitter<RegistrationState> emit,
  ) {
    // обновление текущего знач password
    _password = event.password;
    // обновление  _passwordError
    _passwordError = _validatePassword();
    // обновление  _passwordErrorConfirmation
    _passwordConfirmationError = _validatePasswordConfirmation();
    // эмитим есть ли ошибка или нет. обновляем инфу с филдами
    emit(_calculateFieldsInfo());
  }

  // потеря фокуса пароля
  FutureOr<void> _onPasswordFocusLost(
    final RegistrationPasswordFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordError = true;
    emit(_calculateFieldsInfo());
  }

  // метод ввода повторно пароля
  FutureOr<void> _onPasswordConfirmationChanged(
    final RegistrationPasswordConfirmationChange event,
    final Emitter<RegistrationState> emit,
  ) {
    // обновление текущего знач password
    _passwordConfirmation = event.passwordConfirmation;
    // обновление  _passwordErrorConfirmation
    _passwordConfirmationError = _validatePasswordConfirmation();
    // эмитим есть ли ошибка или нет. обновляем инфу с филдами
    emit(_calculateFieldsInfo());
  }

  // потеря фокуса поля повторного ввода пароля
  FutureOr<void> _onPasswordConfirmationFocusLost(
    final RegistrationPasswordConfirmationFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordConfirmationError = true;
    emit(_calculateFieldsInfo());
  }

  // метод ввода имени
  FutureOr<void> _onNameChanged(
    final RegistrationNameChange event,
    final Emitter<RegistrationState> emit,
  ) {
    // обновление текущего знач имени
    _name = event.name;
    // обновление
    _nameError = _validateName();
    // эмитим есть ли ошибка или нет. обновляем инфу с филдами
    emit(_calculateFieldsInfo());
  }

  // потеря фокуса имени
  FutureOr<void> _onNameFocusLost(
    final RegistrationNameFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
  }

  // при нажатии на создать подсвечивает ошибки ввода
  FutureOr<void> _onCreateAccount(
    final RegistrationCreateAccount event,
    final Emitter<RegistrationState> emit,
  ) async {
    _highlightEmailError = true;
    _highlightPasswordError = true;
    _highlightPasswordConfirmationError = true;
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
    // если есть ошибки, блокируем переход на след страницу по кнопке СОЗДАТЬ
    final haveError = _emailError != null ||
        _passwordError != null ||
        _passwordConfirmationError != null ||
        _nameError != null;
    if (haveError) {
      return;
    }
    emit(const RegistrationInProgress());
    final response = await _register();
    if (response.isRight) {
      final userWithTokens = response.right;
      await UserRepository.getInstance().setItem(userWithTokens.user);
      await TokenRepository.getInstance().setItem(userWithTokens.token);
      await RefreshTokenRepository.getInstance()
          .setItem(userWithTokens.refreshToken);
      emit(const RegistrationCompleted());
    } else {
      // TODO handle error
    }
  }

  // реализуем запрос в сеть в сеть при регистрации для возвращения токена авторизации
  Future<Either<ApiError, UserWithTokensDto>> _register() async {
    final response = await UnauthorizedApiService.getInstance().register(
      email: _email,
      password: _password,
      name: _name,
      avatarUrl: _avatarBuilder(_avatarKey),
    );
    // TODO
    return response;
  }

  // метод для сбора инфы с полей будет выдавать инфу об всех ошибках
  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highlightEmailError ? _emailError : null,
      passwordError: _highlightPasswordError ? _passwordError : null,
      passwordConfirmationError: _highlightPasswordConfirmationError
          ? _passwordConfirmationError
          : null,
      nameError: _highlightNameError ? _nameError : null,
    );
  }

  // метод по ошибкам ввода почты
  RegistarationEmailError? _validateEmail() {
    if (_email.isEmpty) {
      return RegistarationEmailError.empty;
    }
    if (!EmailValidator.validate(_email)) {
      return RegistarationEmailError.invalide;
    }
    return null;
  }

  // метод по ошибкам ввода password
  RegistarationPasswordError? _validatePassword() {
    if (_password.isEmpty) {
      return RegistarationPasswordError.empty;
    }
    if (_password.length < 6) {
      return RegistarationPasswordError.tooShort;
    }
    if (_registrationPasswordRegexp.hasMatch(_password)) {
      return RegistarationPasswordError.wrongSymbols;
    }
    return null;
  }

  // метод по ошибкам повторного ввода password
  RegistarationPasswordConfirmationError? _validatePasswordConfirmation() {
    if (_passwordConfirmation.isEmpty) {
      return RegistarationPasswordConfirmationError.empty;
    }
    if (_password != _passwordConfirmation) {
      return RegistarationPasswordConfirmationError.different;
    }
    return null;
  }

  // метод по ошибкам name
  RegistarationNameError? _validateName() {
    if (_name.isEmpty) {
      return RegistarationNameError.empty;
    }
    return null;
  }
}
