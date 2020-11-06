import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'formula.g.dart';

@JsonSerializable()
class Formula extends Equatable {
  final String path;
  final String uid;
  final String tex;
  final List<String> tags;
  @JsonKey(fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  final String title;

  @JsonKey(
      ignore: false,
      includeIfNull: true,
      toJson: _routeToJson,
      fromJson: _routeFromJson)
  final String route;
  Formula(
      {@required this.path,
      @required this.uid,
      @required this.tex,
      @required this.tags,
      @required this.title,
      @required this.timestamp,
      this.route});

  @override
  List<Object> get props => [path, uid, tex, tags, title];

  Map<String, dynamic> toJson() => _$FormulaToJson(this);

  factory Formula.fromJson(Map<String, dynamic> json) =>
      _$FormulaFromJson(json);
  static String _routeToJson(String route) {
    return '/formula';
  }

  static String _routeFromJson(String json) {
    return '/formula';
  }

  static Timestamp _timestamoFromJson(Timestamp json) {
    return json;
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }
}
// await Firestore.instance.collection('formulas').add({
//   'path': path,
//   'uid': GetIt.I.get<FirebaseUser>().uid,
//   'tex': _controller.text,
//   'tags': tags
// });
