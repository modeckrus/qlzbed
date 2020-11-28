import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:firedart/auth/user_gateway.dart' as fd;

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  final String name;
  final String surname;
  final String uid;

  User({
    @required this.name,
    @required this.surname,
    @required this.uid,
  });

  @override
  List<Object> get props => [name, surname, uid];

  bool get isSetted =>
      name != null &&
      surname != null &&
      uid != null &&
      name != "" &&
      surname != "" &&
      uid != "";

  factory User.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return _$UserFromJson(json);
    } else {
      return User(name: '', surname: '', uid: '');
    }
  }

  factory User.fromFd(fd.User fduser) {
    return User(
        name: fduser.displayName, surname: fduser.email, uid: fduser.id);
  }
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
