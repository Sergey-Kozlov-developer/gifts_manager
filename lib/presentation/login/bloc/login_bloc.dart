import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/presentation/login/model/models.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // regularExp password
  final passwordRegexp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  LoginBloc() : super(LoginState.initial()) {
    // при нажатии кнопки Войти переходим на экран Home
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    // валидации и проверки почты и пароля
    on<LoginEmailChanged>(_emailChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    // окно показа ошибки
    on<LoginRequestErrorShowed>(_requestErrorShow);
  }

  FutureOr<void> _loginButtonClicked(
    LoginLoginButtonClicked event,
    Emitter<LoginState> emit,
  ) async {
    // если валидация почты и пароля прошла,
    // то аунтефик завершена верно и переходим на HomePage
    if (state.allFieldsValid) {
      // имитируемый ответ от сервера response
      final response =
          await _login(email: state.email, password: state.password);
      // emit(state.copyWith(requestError: RequestError.unknown));
      if (response == null) {
        // возращение типа ошибки
        emit(state.copyWith(authenticated: true));
      } else {
        switch (response) {
          case LoginError.emailNotExist:
            emit(state.copyWith(emailError: EmailError.notExist));
            break;
          case LoginError.wrongPassword:
            emit(state.copyWith(passwordError: PasswordError.wrongPassword));
            break;
          case LoginError.other:
            emit(state.copyWith(requestError: RequestError.unknown));
            break;
        }
      }
    }
  }

  // обработка ошибок ввода
  // ИМИТАЦИЯ РАБОТЫ СЕРВЕРА , на реальном проекте немного по другому
  Future<LoginError?> _login({
    required final String email,
    required final String password,
  }) async {
    final successfulResponse = Random().nextBool();
    if (successfulResponse) {
      return null;
    }
    return LoginError.values[Random().nextInt(LoginError.values.length)];
  }

  // валидация email
  FutureOr<void> _emailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final newEmail = event.email; // эвент смен email
    final emailValid = _emailValid(newEmail);
    emit(
      state.copyWith(
        email: newEmail,
        emailValid: emailValid,
        emailError: EmailError.noError, // сброс ошибки почты
        authenticated: false,
      ),
    );
  }

  // валидация email EmailValidator
  bool _emailValid(final String email) {
    return EmailValidator.validate(email);
  }

  // валидация password
  FutureOr<void> _passwordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final newPassword = event.password; // эвент смен password
    final passwordValid = _passwordValid(newPassword);
    emit(
      state.copyWith(
        password: newPassword,
        passwordValid: passwordValid,
        passwordError: PasswordError.noError, // сброс ошибки пароля
        authenticated: false,
      ),
    );
  }

  // валидация regularExp
  bool _passwordValid(final String password) {
    return passwordRegexp.hasMatch(password);
  }

  // сброс всех прочих ошибок other
  FutureOr<void> _requestErrorShow(
    LoginRequestErrorShowed event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(requestError: RequestError.noError),
    );
  }

/*=== Для дебага===*/

// для вывод всех евентов в консоль
// удобно при дебаге
//   @override
//   void onEvent(LoginEvent event) {
//     debugPrint('Login Bloc. Event happened: $event');
//     super.onEvent(event);
//   }
//
//   // метод, который позволяет какие транзишены есть
//   @override
//   void onTransition(Transition<LoginEvent, LoginState> transition) {
//     debugPrint('Login Bloc. Transition happened: $transition');
//     super.onTransition(transition);
//   }
}

// для обработки ошибок
enum LoginError { emailNotExist, wrongPassword, other }
