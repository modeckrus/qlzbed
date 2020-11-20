import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../entities/moderate_base_curriculum.dart';
import '../../../entities/moderationCurriculum.dart';

part 'curriculum_event.dart';
part 'curriculum_state.dart';

class CurriculumBloc extends Bloc<CurriculumEvent, CurriculumState> {
  CurriculumBloc() : super(CurriculumFailS());

  @override
  Stream<CurriculumState> mapEventToState(
    CurriculumEvent event,
  ) async* {
    if (event is CurriculumDescriptionChangeE) {
      yield CurriculumDescChangedS();
    }
    if (event is CurriculumChangedE) {
      final curriculum = event.curriculum;
      final baseCurriculum = event.baseCurriculum;
      if (curriculum == null || baseCurriculum == null) {
        yield CurriculumFailS();
      } else {
        bool titleOk = baseCurriculum.title != null &&
            baseCurriculum.title != '' &&
            baseCurriculum.title != ' ' &&
            baseCurriculum.title.length > 2;
        bool learnsOk = curriculum.learns != null &&
            curriculum.learns != List() &&
            curriculum.learns.length > 2;
        bool requirmentsOk = curriculum.requirments != null &&
            curriculum.requirments != List() &&
            curriculum.requirments.length > 2;
        bool shortOk = curriculum.shortDesc != null &&
            curriculum.shortDesc != '' &&
            curriculum.shortDesc != ' ' &&
            curriculum.shortDesc.length > 20;
        bool timeOk = curriculum.time != null && curriculum.time > 1;
        if (titleOk && learnsOk && requirmentsOk && shortOk && timeOk) {
          yield CurriculumSuccesS();
        } else {
          yield CurriculumFailS();
        }
      }
    }
    if (event is CurriculumFailE) {
      yield CurriculumFailS();
    }
  }
}
