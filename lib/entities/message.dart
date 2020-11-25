import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'timestamp.dart';
import 'user.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  @JsonKey(includeIfNull: false)
  final String message;
  @JsonKey(includeIfNull: false)
  final List<String> attachment;
  @JsonKey(
      required: true, fromJson: _timestamoFromJson, toJson: _timestampToJson)
  final Timestamp timestamp;
  @JsonKey(required: true, fromJson: _userFromJson, toJson: _userToJson)
  final User from;
  @JsonKey(required: true)
  final String chatId;
  @JsonKey(includeIfNull: false)
  final Message replyToMessage;
  @JsonKey(includeIfNull: false)
  final bool readed;

  Message(
      {this.message,
      this.attachment,
      @required this.timestamp,
      @required this.from,
      @required this.chatId,
      this.replyToMessage,
      this.readed});

  static Timestamp _timestamoFromJson(Timestamp json) {
    // print('Timestamp val: ' + json.toString());
    // final timestamp = json['timestamp'] as Timestamp;
    // return timestamp;
    return json;
  }

  static Map<String, dynamic> _userToJson(User user) {
    return user.toJson();
  }

  static User _userFromJson(Map<String, dynamic> json) {
    // print('Timestamp val: ' + json.toString());
    // final timestamp = json['timestamp'] as Timestamp;
    // return timestamp;
    return User.fromJson(json);
  }

  static Timestamp _timestampToJson(Timestamp timestamp) {
    return timestamp;
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  List<Object> get props =>
      [message, attachment, timestamp, from, chatId, replyToMessage];
}
