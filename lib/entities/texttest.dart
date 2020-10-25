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

  TextTest(
      {@required this.path,
      @required this.uid,
      @required this.answers,
      @required this.tags,
      @required this.title});

  @override
  List<Object> get props => [path, uid, answers, tags, title];

  Map<String, dynamic> toJson() => _$TextTestToJson(this);

  factory TextTest.fromJson(Map<String, dynamic> json) =>
      _$TextTestFromJson(json);
}
