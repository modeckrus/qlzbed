import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:qlzbed/entities/test_base.dart';

import 'answer.dart';

part 'check_test.g.dart';

@JsonSerializable()
class CheckTest extends TestBase {
  final String question;
  final List<Answer> answers;

  CheckTest({@required this.question, @required this.answers})
      : super(question: question, type: 'checktest');

  factory CheckTest.fromJson(Map<String, dynamic> json) =>
      _$CheckTestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckTestToJson(this);

  @override
  List<Object> get props => [question, answers];
}
