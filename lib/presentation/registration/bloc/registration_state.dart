part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

// state всех ошибок если не ввести ничего в поля
class RegistrationFieldsInfo extends RegistrationState {
  final String avatarLink;
  final RegistarationEmailError? emailError;
  final RegistarationPasswordError? passwordError;
  final RegistarationPasswordConfirmationError? passwordConfirmationError;
  final RegistarationNameError? nameError;

  const RegistrationFieldsInfo({
    required this.avatarLink,
    this.emailError,
    this.passwordError,
    this.passwordConfirmationError,
    this.nameError,
  });

  @override
  List<Object?> get props => [
        avatarLink,
        emailError,
        passwordError,
        passwordConfirmationError,
        nameError,
      ];
}

class RegistrationError extends RegistrationState {
  final RequestError requestError;

  const RegistrationError(this.requestError);

  @override
  // TODO: implement props
  List<Object?> get props => [requestError];
}

// сейчас мы логинимся
class RegistrationInProgress extends RegistrationState {
  const RegistrationInProgress();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
