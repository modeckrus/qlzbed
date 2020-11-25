import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fstateMinimum.dart';
import 'timestamp.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
  @JsonKey(toJson: lessonsToJson, fromJson: lessonsFromJson)
  final List<FStateMinimum> lessons;
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  Unit(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.lessons,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$UnitToJson(this);

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/unit';
  }

  static String _routeFromJson(String json) {
    return '/unit';
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
}
