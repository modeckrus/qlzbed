// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: Group._timestamoFromJson(json['timestamp'] as Timestamp),
    route: Group._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'uid': instance.uid,
      'timestamp': Group._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'tags': instance.tags,
      'route': Group._routeToJson(instance.route),
    };
