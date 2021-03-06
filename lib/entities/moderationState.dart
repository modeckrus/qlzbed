import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'moderationState.g.dart';

@JsonSerializable()
class ModerationState extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  // final String lang;
  final String title;
  final List<String> tags;
  final bool isModerating;
  @JsonKey(includeIfNull: false)
  final String moderator;
  final String humanPath;
  final String route;
  final String lang;
  ModerationState(
      {@required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      @required this.humanPath,
      @required this.isModerating,
      @required this.lang,
      this.moderator,
      this.route});
  @override
  List<Object> get props => [title, tags, uid, timestamp, lang];

  Map<String, dynamic> toJson() => _$ModerationStateToJson(this);

  factory ModerationState.fromJson(Map<String, dynamic> json) =>
      _$ModerationStateFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }
}
