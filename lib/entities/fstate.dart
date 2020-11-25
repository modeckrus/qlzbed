import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'fstate.g.dart';

@JsonSerializable()
class FState extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String lang;
  final String title;
  final List<String> tags;
  @JsonKey(
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  FState(
      {@required this.lang,
      @required this.title,
      @required this.tags,
      @required this.uid,
      @required this.timestamp,
      this.route});
  @override
  List<Object> get props => [lang, title, tags, uid, timestamp];

  Map<String, dynamic> toJson() => _$FStateToJson(this);

  factory FState.fromJson(Map<String, dynamic> json) => _$FStateFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }
}
