// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fstate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FState _$FStateFromJson(Map<String, dynamic> json) {
  return FState(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: FState._timestamoFromJson(json['timestamp'] as Timestamp),
    route: json['route'] as String,
  );
}

Map<String, dynamic> _$FStateToJson(FState instance) => <String, dynamic>{
      'uid': instance.uid,
      'timestamp': FState._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'tags': instance.tags,
      'route': instance.route,
    };
