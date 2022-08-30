import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gifts_manager/data/http/api_error_type.dart';
import 'package:gifts_manager/data/http/model/api_error.dart';
import 'package:gifts_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gifts_manager/data/http/unauthorized_api_service.dart';
import 'package:gifts_manager/data/model/request_error.dart';
import 'package:gifts_manager/data/repository/refresh_token_repository.dart';
import 'package:gifts_manager/data/repository/token_repository.dart';
import 'package:gifts_manager/data/repository/user_repository.dart';
import 'package:gifts_manager/presentation/login/model/models.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
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
      // ответ от сервера response
      final response =
          await _login(email: state.email, password: state.password);
      // emit(state.copyWith(requestError: RequestError.unknown));
      if (response.isRight) {
        final userWithTokens = response.right;
        await UserRepository.getInstance().setItem(userWithTokens.user);
        await TokenRepository.getInstance().setItem(userWithTokens.token);
        await RefreshTokenRepository.getInstance()
            .setItem(userWithTokens.refreshToken);
        // возращение типа ошибки
        emit(state.copyWith(authenticated: true));
      } else {
        final apiError = response.left;
        switch (apiError.errorType) {
          case ApiErrorType.incorrectPassword:
            emit(state.copyWith(passwordError: PasswordError.wrongPassword));
            break;
          case ApiErrorType.notFound:
            emit(state.copyWith(emailError: EmailError.notExist));
            break;
          default:
            emit(state.copyWith(requestError: RequestError.unknown));
            break;
        }
      }
    }
  }

  // обработка ошибок ввода
  // работа сервера при логине
  Future<Either<ApiError, UserWithTokensDto>> _login({
    required final String email,
    required final String password,
  }) async {
    final response = await UnauthorizedApiService.getInstance().login(
      email: email,
      password: password,
    );
    return response;
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
    return password.length >= 6;
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
