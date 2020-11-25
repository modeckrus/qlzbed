part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class SettingUser extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final User user;
  const Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthenticationState {}

class LogPageS extends AuthenticationState {}
