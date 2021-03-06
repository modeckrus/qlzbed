part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class SingedUp extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class WannaLogIn extends AuthenticationEvent {}

class LogPageE extends AuthenticationEvent {}
