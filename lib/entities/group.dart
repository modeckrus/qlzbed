import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  Group(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/list';
  }

  static String _routeFromJson(String json) {
    return '/list';
  }
}
