part of 'curriculum_bloc.dart';

abstract class CurriculumState extends Equatable {
  const CurriculumState();

  @override
  List<Object> get props => [];
}

class CurriculumFailS extends CurriculumState {}

class CurriculumSuccesS extends CurriculumState {}

class CurriculumDescChangedS extends CurriculumState {}
