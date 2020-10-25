import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Equatable {
  final String lang;
  final String title;
  final List<String> tags;

  Group({@required this.lang, @required this.title, @required this.tags});
  @override
  List<Object> get props => [lang, title, tags];

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
