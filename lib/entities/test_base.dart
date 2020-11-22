import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'test_base.g.dart';

@JsonSerializable()
class TestBase extends Equatable {
  final String question;
  final String type;

  TestBase({@required this.question, @required this.type});

  @override
  List<Object> get props => [question, type];

  factory TestBase.fromJson(Map<String, dynamic> json) =>
      _$TestBaseFromJson(json);
  Map<String, dynamic> toJson() => _$TestBaseToJson(this);
}
