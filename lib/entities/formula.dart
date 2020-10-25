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
  final String title;

  Formula(
      {@required this.path,
      @required this.uid,
      @required this.tex,
      @required this.tags,
      @required this.title});

  @override
  List<Object> get props => [path, uid, tex, tags, title];

  Map<String, dynamic> toJson() => _$FormulaToJson(this);

  factory Formula.fromJson(Map<String, dynamic> json) =>
      _$FormulaFromJson(json);
}
// await Firestore.instance.collection('formulas').add({
//   'path': path,
//   'uid': GetIt.I.get<FirebaseUser>().uid,
//   'tex': _controller.text,
//   'tags': tags
// });
