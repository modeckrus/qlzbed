import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'fstateMinimum.g.dart';

@JsonSerializable()
class FStateMinimum extends Equatable {
  final String uid;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String title;
  final String path;
  @JsonKey(
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  FStateMinimum(
      {@required this.title,
      @required this.uid,
      @required this.timestamp,
      @required this.path,
      @required this.route});
  @override
  List<Object> get props => [title, uid, timestamp];

  Map<String, dynamic> toJson() => _$FStateMinimumToJson(this);

  factory FStateMinimum.fromJson(Map<String, dynamic> json) =>
      _$FStateMinimumFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }
}
