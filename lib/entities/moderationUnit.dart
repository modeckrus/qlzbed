import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fstateMinimum.dart';

part 'moderationUnit.g.dart';

@JsonSerializable()
class ModerationUnit extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
  @JsonKey(toJson: lessonsToJson, fromJson: lessonsFromJson)
  final List<FStateMinimum> lessons;
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
  ModerationUnit(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.humanPath,
      @required this.isModerating,
      @required this.lessons,
      this.moderator,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$ModerationUnitToJson(this);

  factory ModerationUnit.fromJson(Map<String, dynamic> json) =>
      _$ModerationUnitFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

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

  static String _routeToJson(String route) {
    return '/unit';
  }

  static String _routeFromJson(String json) {
    return '/unit';
  }
}
