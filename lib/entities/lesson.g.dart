// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: Lesson._timestamoFromJson(json['timestamp'] as Timestamp),
    states: Lesson.statesFromJson(json['states'] as List),
    route: Lesson._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'uid': instance.uid,
      'timestamp': Lesson._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'tags': instance.tags,
      'states': Lesson.statesToJson(instance.states),
      'route': Lesson._routeToJson(instance.route),
    };
