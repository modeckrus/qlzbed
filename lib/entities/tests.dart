import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'test_base.dart';
import 'timestamp.dart';

part 'tests.g.dart';

@JsonSerializable()
class Tests extends Equatable {
  final String path;
  final String uid;
  final List<String> tags;
  final String title;
  final String lang;
  final List<TestBase> tests;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  Tests(
      {@required this.path,
      @required this.uid,
      @required this.tags,
      @required this.title,
      @required this.timestamp,
      @required this.lang,
      @required this.tests,
      this.route});

  @override
  List<Object> get props => [path, uid, tags, title];

  Map<String, dynamic> toJson() => _$TestsToJson(this);

  factory Tests.fromJson(Map<String, dynamic> json) => _$TestsFromJson(json);

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
