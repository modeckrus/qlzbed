part of 'perferences_bloc.dart';

abstract class PerferencesEvent extends Equatable {
  const PerferencesEvent();

  @override
  List<Object> get props => [];
}

class PerferencesAppStarted extends PerferencesEvent {}

class PerferencesSettingChanged extends PerferencesEvent {
  final String lang;
  final ThemeMode themeMode;
  PerferencesSettingChanged({this.lang, this.themeMode});
  @override
  List<Object> get props => [lang, themeMode];
}
