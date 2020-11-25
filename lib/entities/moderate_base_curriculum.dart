import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'moderate_base_curriculum.g.dart';

@JsonSerializable()
class ModerateBaseCurriculum extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
  final int time;
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
  ModerateBaseCurriculum(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.time,
      @required this.isModerating,
      @required this.humanPath,
      this.moderator,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$ModerateBaseCurriculumToJson(this);

  factory ModerateBaseCurriculum.fromJson(Map<String, dynamic> json) =>
      _$ModerateBaseCurriculumFromJson(json);

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

  int size() {
    return this.toString().length * 8;
  }
}
