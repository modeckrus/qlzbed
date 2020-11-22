import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qlzbed/entities/test_base.dart';

part 'texttest.g.dart';

@JsonSerializable()
class TextTest extends TestBase {
  final String question;
  final List<String> answers;

  TextTest({@required this.question, @required this.answers})
      : super(question: question, type: 'texttest');

  factory TextTest.fromJson(Map<String, dynamic> json) =>
      _$TextTestFromJson(json);

  Map<String, dynamic> toJson() => _$TextTestToJson(this);

  @override
  List<Object> get props => [question, answers];
}
