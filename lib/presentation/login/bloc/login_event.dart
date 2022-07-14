part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

// Event enter email login
class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

// Event login password
class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

// Event нажатие на войти
class LoginLoginButtonClicked extends LoginEvent {

  const LoginLoginButtonClicked();

  @override
  List<Object?> get props => [];
}

// Event обнубления ошибки в Snackbar при появлении всех прочих ошибок other
class LoginRequestErrorShowed extends LoginEvent {
  const LoginRequestErrorShowed();

  @override
  List<Object?> get props => [];
}