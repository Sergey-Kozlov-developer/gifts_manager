part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}
// не авторизованы
class SplashUnauthorized extends SplashState {
  const SplashUnauthorized();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
// когда авторизованы
class SplashAuthorized extends SplashState {
  const SplashAuthorized();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}