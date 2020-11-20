import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fstateMinimum.dart';

part 'moderationCurriculum.g.dart';

@JsonSerializable()
class ModerationCurriculum extends Equatable {
  final String descPath;
  final List<String> learns;
  final List<String> requirments;
  final int lessonsCount;
  final int time;
  final List<String> attachment;
  @JsonKey(toJson: lessonsToJson, fromJson: lessonsFromJson)
  final List<FStateMinimum> lessons;
  final String shortDesc;
  ModerationCurriculum(
      {@required this.lessons,
      @required this.descPath,
      // @required this.learnPath,
      @required this.lessonsCount,
      @required this.time,
      @required this.learns,
      @required this.requirments,
      @required this.shortDesc,
      this.attachment});
  @override
  List<Object> get props => [
        descPath,
        learns,
        requirments,
        lessonsCount,
        lessons,
        time,
        attachment,
        shortDesc
      ];

  Map<String, dynamic> toJson() => _$ModerationCurriculumToJson(this);

  factory ModerationCurriculum.fromJson(Map<String, dynamic> json) =>
      _$ModerationCurriculumFromJson(json);

  static lessonsToJson(List<FStateMinimum> states) {
    final json = List<Map<String, dynamic>>();
    states.forEach((element) {
      json.add(element.toJson());
    });
    return json;
  }

  static List<FStateMinimum> lessonsFromJson(List<dynamic> json) {
    return json
        ?.map((e) => e == null
            ? null
            : FStateMinimum.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }
}
