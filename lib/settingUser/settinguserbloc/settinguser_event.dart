part of 'settinguser_bloc.dart';

abstract class SettinguserEvent extends Equatable {
  const SettinguserEvent();

  @override
  List<Object> get props => [];
}

class SettinguserStartEditing extends SettinguserEvent {}

class SettinguserSave extends SettinguserEvent {}

class SettinguserChange extends SettinguserEvent {
  final User user;

  SettinguserChange(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'SettinguserChange: ' + user.toString();
  }
}

class SettinguserAppStarted extends SettinguserEvent {}
