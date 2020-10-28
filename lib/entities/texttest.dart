import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'texttest.g.dart';

@JsonSerializable()
class TextTest extends Equatable {
  final String path;
  final String uid;
  final List<String> answers;
  final List<String> tags;
  final String title;
  final String lang;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  TextTest(
      {@required this.path,
      @required this.uid,
      @required this.answers,
      @required this.tags,
      @required this.title,
      @required this.timestamp,
      @required this.lang,
      this.route});

  @override
  List<Object> get props => [path, uid, answers, tags, title, timestamp];

  Map<String, dynamic> toJson() => _$TextTestToJson(this);

  factory TextTest.fromJson(Map<String, dynamic> json) =>
      _$TextTestFromJson(json);
  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/textTest';
  }

  static String _routeFromJson(String json) {
    return '/textTest';
  }
}
