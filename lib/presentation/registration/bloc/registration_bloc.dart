import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/presentation/registration/model/errors.dart';

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
    on<RegistrationPasswordConfirmationFocusLost>(_onPasswordConfirmationFocusLost);
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
  ) {
    _highlightEmailError = true;
    _highlightPasswordError = true;
    _highlightPasswordConfirmationError = true;
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
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
