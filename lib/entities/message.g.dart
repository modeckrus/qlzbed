// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['timestamp', 'from', 'chatId']);
  return Message(
    message: json['message'] as String,
    attachment: (json['attachment'] as List)?.map((e) => e as String)?.toList(),
    timestamp: Message._timestamoFromJson(json['timestamp'] as Timestamp),
    from: Message._userFromJson(json['from'] as Map<String, dynamic>),
    chatId: json['chatId'] as String,
    replyToMessage: json['replyToMessage'] == null
        ? null
        : Message.fromJson(json['replyToMessage'] as Map<String, dynamic>),
    readed: json['readed'] as bool,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('attachment', instance.attachment);
  val['timestamp'] = Message._timestampToJson(instance.timestamp);
  val['from'] = Message._userToJson(instance.from);
  val['chatId'] = instance.chatId;
  writeNotNull('replyToMessage', instance.replyToMessage);
  writeNotNull('readed', instance.readed);
  return val;
}
