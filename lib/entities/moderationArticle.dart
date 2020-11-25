import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';

part 'moderationArticle.g.dart';

@JsonSerializable()
class ModerationArticle extends Equatable {
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
  @JsonKey(
    toJson: _routeToJson,
    fromJson: _routeFromJson,
    ignore: false,
    includeIfNull: true,
  )
  final String route;
  ModerationArticle(
      {@required this.path,
      @required this.uid,
      @required this.tags,
      @required this.title,
      @required this.timestamp,
      @required this.isModerating,
      @required this.humanPath,
      @required this.lang,
      this.moderator,
      this.route});

  @override
  List<Object> get props => [path, uid, tags, title, lang];

  Map<String, dynamic> toJson() => _$ModerationArticleToJson(this);

  factory ModerationArticle.fromJson(Map<String, dynamic> json) =>
      _$ModerationArticleFromJson(json);

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  static String _routeToJson(String route) {
    return '/article';
  }

  static String _routeFromJson(String json) {
    return '/article';
  }
}
