import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dialog.g.dart';

@JsonSerializable(explicitToJson: true)
class MDialog extends Equatable {
  final String name;
  final String surname;
  final String avatar;
  final String uid;
  final String lastMessage;
  final bool isPinned;
  final int missedMessages;
  MDialog(
      {@required this.name,
      @required this.surname,
      @required this.avatar,
      @required this.lastMessage,
      @required this.uid,
      @required this.isPinned,
      @required this.missedMessages});

  @override
  List<Object> get props => [name, surname, avatar];

  bool get isSetted =>
      name != null &&
      surname != null &&
      avatar != null &&
      uid != null &&
      lastMessage != null &&
      isPinned != null &&
      missedMessages != null &&
      name != "" &&
      surname != "" &&
      uid != "" &&
      lastMessage != "" &&
      avatar != "";
  factory MDialog.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return _$MDialogFromJson(json);
    } else {
      return MDialog(
          name: '',
          surname: '',
          avatar: '',
          uid: '',
          lastMessage: '',
          isPinned: false,
          missedMessages: 0);
    }
  }
  Map<String, dynamic> toJson() => _$MDialogToJson(this);
  @override
  String toString() {
    return toJson().toString();
  }
}
