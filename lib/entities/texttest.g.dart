// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'texttest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTest _$TextTestFromJson(Map<String, dynamic> json) {
  return TextTest(
    path: json['path'] as String,
    uid: json['uid'] as String,
    answers: (json['answers'] as List)?.map((e) => e as String)?.toList(),
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp: TextTest._timestamoFromJson(json['timestamp'] as Timestamp),
    route: TextTest._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$TextTestToJson(TextTest instance) => <String, dynamic>{
      'path': instance.path,
      'uid': instance.uid,
      'answers': instance.answers,
      'tags': instance.tags,
      'title': instance.title,
      'timestamp': TextTest._timestampToJson(instance.timestamp),
      'route': TextTest._routeToJson(instance.route),
    };
