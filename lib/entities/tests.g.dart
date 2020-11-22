// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tests _$TestsFromJson(Map<String, dynamic> json) {
  return Tests(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp: Tests._timestamoFromJson(json['timestamp'] as Timestamp),
    lang: json['lang'] as String,
    tests: (json['tests'] as List)
        ?.map((e) =>
            e == null ? null : TestBase.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    route: Tests._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$TestsToJson(Tests instance) => <String, dynamic>{
      'path': instance.path,
      'uid': instance.uid,
      'tags': instance.tags,
      'title': instance.title,
      'lang': instance.lang,
      'tests': instance.tests,
      'timestamp': Tests._timestampToJson(instance.timestamp),
      'route': Tests._routeToJson(instance.route),
    };
