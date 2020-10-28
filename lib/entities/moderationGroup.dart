import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'moderationGroup.g.dart';

@JsonSerializable()
class ModerationGroup extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
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
  ModerationGroup(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.humanPath,
      @required this.isModerating,
      this.moderator,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$ModerationGroupToJson(this);

  factory ModerationGroup.fromJson(Map<String, dynamic> json) =>
      _$ModerationGroupFromJson(json);

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
