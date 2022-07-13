part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final EmailError emailError;
  final String password;
  final PasswordError passwordError;
  final bool emailValid;
  final bool passwordValid;
  final bool authenticated;

  const LoginState({
    required this.email,
    required this.emailError,
    required this.password,
    required this.passwordError,
    required this.emailValid,
    required this.passwordValid,
    required this.authenticated,
  });

  // метод для валидации почты и пароля
  bool get allFieldsValid => emailValid && passwordValid;

  // возвращает LoginState
  factory LoginState.initial() => const LoginState(
        email: '',
        emailError: EmailError.noError,
        password: '',
        passwordError: PasswordError.noError,
        emailValid: false,
        passwordValid: false,
        authenticated: false,
      );

  // метод имутирует состояние пересоздавая с нуля
  LoginState copyWith({
    final String? email,
    final EmailError? emailError,
    final String? password,
    final PasswordError? passwordError,
    final bool? emailValid,
    final bool? passwordValid,
    final bool? authenticated,
  }) {
    // возвращаем новый объект, в котором все поля остаются прежними
    // но при этом заменяются на новые
    return LoginState(
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      password: password ?? this.password,
      passwordError: passwordError ?? this.passwordError,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      authenticated: authenticated ?? this.authenticated,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        emailError,
        password,
        passwordError,
        emailValid,
        passwordValid,
        authenticated,
      ];
}
