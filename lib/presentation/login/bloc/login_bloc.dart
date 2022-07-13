import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    // при нажатии кнопки Войти переходим на экран Home
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    // валидации и проверки почты и пароля
    on<LoginEmailChanged>(_emailChanged);
    on<LoginPasswordChanged>(_passwordChanged);
  }

  FutureOr<void> _loginButtonClicked(
    LoginLoginButtonClicked event,
    Emitter<LoginState> emit,
  ) {
    // если валидация почты и пароля прошла,
    // то аунтефик завершена верно и переходим на HomePage
    if (state.passwordValid && state.emailValid) {
      emit(state.copyWith(authenticated: true));
    }
  }

  // валидация email
  FutureOr<void> _emailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final newEmail = event.email; // эвент смен email
    final emailValid = newEmail.length > 4;
    emit(state.copyWith(email: newEmail, emailValid: emailValid));
  }

  // валидация password
  FutureOr<void> _passwordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final newPassword = event.password; // эвент смен password
    final passwordValid = newPassword.length >= 8;
    emit(state.copyWith(password: newPassword, passwordValid: passwordValid));
  }

  /*=== Для дебага===*/

  // для вывод всех евентов в консоль
  // удобно при дебаге
  @override
  void onEvent(LoginEvent event) {
    debugPrint('Login Bloc. Event happened: $event');
    super.onEvent(event);
  }

  // метод, который позволяет какие транзишены есть
  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    debugPrint('Login Bloc. Transition happened: $transition');
    super.onTransition(transition);
  }
}
