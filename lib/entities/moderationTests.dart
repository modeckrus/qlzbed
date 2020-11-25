import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'test_base.dart';
import 'timestamp.dart';

part 'moderationTests.g.dart';

@JsonSerializable()
class ModerationTests extends Equatable {
  final String path;
  final String uid;
  final List<String> tags;
  final String title;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final bool isModerating;
  @JsonKey(includeIfNull: false)
  final String moderator;
  final String humanPath;
  final String lang;
  final List<TestBase> tests;
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  ModerationTests(
      {@required this.path,
      @required this.uid,
      @required this.tags,
      @required this.title,
      @required this.timestamp,
      @required this.isModerating,
      @required this.humanPath,
      @required this.lang,
      @required this.tests,
      this.moderator,
      this.route});

  @override
  List<Object> get props => [path, uid, tags, title, lang];

  Map<String, dynamic> toJson() => _$ModerationTestsToJson(this);

  factory ModerationTests.fromJson(Map<String, dynamic> json) =>
      _$ModerationTestsFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/tests';
  }

  static String _routeFromJson(String json) {
    return '/tests';
  }
}
