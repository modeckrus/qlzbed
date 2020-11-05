// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unit _$UnitFromJson(Map<String, dynamic> json) {
  return Unit(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: Unit._timestamoFromJson(json['timestamp'] as Timestamp),
    lessons: Unit.lessonsFromJson(json['lessons'] as List),
    route: Unit._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'uid': instance.uid,
      'timestamp': Unit._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'tags': instance.tags,
      'lessons': Unit.lessonsToJson(instance.lessons),
      'route': Unit._routeToJson(instance.route),
    };
