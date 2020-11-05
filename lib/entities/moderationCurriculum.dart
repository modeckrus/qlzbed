import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qlzbed/entities/fstateMinimum.dart';

part 'moderationCurriculum.g.dart';

@JsonSerializable()
class ModerationCurriculum extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final String descPath;
  final String learnPath;
  final List<String> tags;
  final int lessonsCount;
  final int time;
  final List<String> attachment;
  @JsonKey(toJson: unitsToJson, fromJson: unitsFromJson)
  final List<FStateMinimum> units;
  final bool isModerating;
  @JsonKey(includeIfNull: false)
  final String moderator;
  final String humanPath;

  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  ModerationCurriculum(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.units,
      @required this.descPath,
      @required this.learnPath,
      @required this.lessonsCount,
      @required this.time,
      @required this.humanPath,
      @required this.isModerating,
      this.moderator,
      this.attachment,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$ModerationCurriculumToJson(this);

  factory ModerationCurriculum.fromJson(Map<String, dynamic> json) =>
      _$ModerationCurriculumFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/curriculum';
  }

  static String _routeFromJson(String json) {
    return '/curriculum';
  }

  static unitsToJson(List<FStateMinimum> states) {
    final json = List<Map<String, dynamic>>();
    states.forEach((element) {
      json.add(element.toJson());
    });
    return json;
  }

  static List<FStateMinimum> unitsFromJson(List<dynamic> json) {
    return json
        ?.map((e) => e == null
            ? null
            : FStateMinimum.fromJson(e as Map<String, dynamic>))
        ?.toList();
  }
}
