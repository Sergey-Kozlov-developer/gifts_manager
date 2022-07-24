part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

// поле ввода почты при регистрации
class RegistrationEmailChange extends RegistrationEvent {
  final String email;
  const RegistrationEmailChange(this.email);
  @override
  // TODO: implement props
  List<Object?> get props => [email];
}

// поле ввода пароля при регистрации
class RegistrationPasswordChange extends RegistrationEvent {
  final String password;
  const RegistrationPasswordChange(this.password);
  @override
  // TODO: implement props
  List<Object?> get props => [password];
}

// поле повторного ввода пароля при регистрации
class RegistrationPasswordConfirmationChange extends RegistrationEvent {
  final String passwordConfirmation;
  const RegistrationPasswordConfirmationChange(this.passwordConfirmation);
  @override
  // TODO: implement props
  List<Object?> get props => [passwordConfirmation];
}

// поле ввода имени при регистрации
class RegistrationNameChange extends RegistrationEvent {
  final String name;
  const RegistrationNameChange(this.name);
  @override
  // TODO: implement props
  List<Object?> get props => [name];
}

// оповещение bloc, что мы потеряли фокус(перешли в другое поле)
class RegistrationEmailFocusLost extends RegistrationEvent {
  const RegistrationEmailFocusLost();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// оповещение bloc, что мы потеряли фокус(перешли в другое поле)
class RegistrationPasswordFocusLost extends RegistrationEvent {
  const RegistrationPasswordFocusLost();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// оповещение bloc, что мы потеряли фокус(перешли в другое поле)
class RegistrationPasswordConfirmationFocusLost extends RegistrationEvent {
  const RegistrationPasswordConfirmationFocusLost();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// оповещение bloc, что мы потеряли фокус(перешли в другое поле)
class RegistrationNameFocusLost extends RegistrationEvent {
  const RegistrationNameFocusLost();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// создание аватара
class RegistrationChangeAvatar extends RegistrationEvent {
  const RegistrationChangeAvatar();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// кнопка создания аккаунта
class RegistrationCreateAccount extends RegistrationEvent {
  const RegistrationCreateAccount();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
