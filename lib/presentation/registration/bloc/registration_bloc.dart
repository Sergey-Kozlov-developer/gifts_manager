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
  static String _avatarBuilder(String key) =>
      'https://avatars.dicebear.com/api/croodles/$key.svg';

  String _avatarKey = _defaultAvatarKey;

  // информация о вводе данных email
  String _email = '';
  bool _highlightEmailError = false;
  RegistarationEmailError? _emailError;
  // информация о вводе данных password
  String _password = '';
  bool _highlightPasswordError = false;
  RegistarationPasswordError? _passwordError;

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
          avatarLink: _avatarBuilder(_defaultAvatarKey),
        )) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChange>(_onEmailChanged);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
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

  // метод для сбора инфы с полей будет выдавать инфу об всех ошибках
  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highlightEmailError ? _emailError : null,
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
}
