import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';

@JsonSerializable(explicitToJson: true)
class Setting extends Equatable {
  ThemeMode themeMode = ThemeMode.system;
  String lang = 'ru';
  Setting({@required this.themeMode, @required this.lang});

  @override
  List<Object> get props => [themeMode, lang];

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this);

  @override
  String toString() {
    return toString().toString();
  }
}
