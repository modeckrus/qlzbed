// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MDialog _$MDialogFromJson(Map<String, dynamic> json) {
  return MDialog(
    name: json['name'] as String,
    surname: json['surname'] as String,
    avatar: json['avatar'] as String,
    lastMessage: json['lastMessage'] as String,
    uid: json['uid'] as String,
    isPinned: json['isPinned'] as bool,
    missedMessages: json['missedMessages'] as int,
  );
}

Map<String, dynamic> _$MDialogToJson(MDialog instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'avatar': instance.avatar,
      'uid': instance.uid,
      'lastMessage': instance.lastMessage,
      'isPinned': instance.isPinned,
      'missedMessages': instance.missedMessages,
    };
