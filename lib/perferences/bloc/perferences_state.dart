part of 'perferences_bloc.dart';

abstract class PerferencesState extends Equatable {
  const PerferencesState();

  @override
  List<Object> get props => [];
}

class PerferencesLoading extends PerferencesState {}

class PerferencesLoaded extends PerferencesState {
  final Setting setting;

  PerferencesLoaded(this.setting);
  @override
  List<Object> get props => [setting];
}
