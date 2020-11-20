part of 'curriculum_bloc.dart';

abstract class CurriculumEvent extends Equatable {
  const CurriculumEvent();

  @override
  List<Object> get props => [];
}

class CurriculumChangedE extends CurriculumEvent {
  final ModerationCurriculum curriculum;
  final ModerateBaseCurriculum baseCurriculum;

  CurriculumChangedE(
      {@required this.curriculum, @required this.baseCurriculum});

  @override
  List<Object> get props => [curriculum, baseCurriculum];

  @override
  String toString() {
    return 'CurriculumChanged: \n ${curriculum.toString() + '\n' + baseCurriculum.toString()}';
  }
}

class CurriculumDescriptionChangeE extends CurriculumEvent {}

class CurriculumFailE extends CurriculumEvent {}
