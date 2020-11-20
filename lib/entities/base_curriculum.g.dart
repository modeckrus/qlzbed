// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_curriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseCurriculum _$BaseCurriculumFromJson(Map<String, dynamic> json) {
  return BaseCurriculum(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        BaseCurriculum._timestamoFromJson(json['timestamp'] as Timestamp),
    time: json['time'] as int,
    humanPath: json['humanPath'] as String,
    route: BaseCurriculum._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$BaseCurriculumToJson(BaseCurriculum instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'timestamp': BaseCurriculum._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'tags': instance.tags,
      'time': instance.time,
      'humanPath': instance.humanPath,
      'route': BaseCurriculum._routeToJson(instance.route),
    };
