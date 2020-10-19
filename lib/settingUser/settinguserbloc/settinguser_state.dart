part of 'settinguser_bloc.dart';

abstract class SettinguserState extends Equatable {
  const SettinguserState();

  @override
  List<Object> get props => [];
}

class SettinguserRead extends SettinguserState {}

class SettinguserEditState extends SettinguserState {}

class SettinguserLoading extends SettinguserState {}

class SettinguserSucces extends SettinguserState {}

class SettinguserError extends SettinguserState {
  final Object error;

  SettinguserError(this.error);

  @override
  List<Object> get props => error;
}

class SettinguserNotFull extends SettinguserState {}
