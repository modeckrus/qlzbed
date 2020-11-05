// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Curriculum _$CurriculumFromJson(Map<String, dynamic> json) {
  return Curriculum(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: Curriculum._timestamoFromJson(json['timestamp'] as Timestamp),
    units: Curriculum.unitsFromJson(json['units'] as List),
    descPath: json['descPath'] as String,
    learnPath: json['learnPath'] as String,
    lessonsCount: json['lessonsCount'] as int,
    time: json['time'] as int,
    humanPath: json['humanPath'] as String,
    attachment: (json['attachment'] as List)?.map((e) => e as String)?.toList(),
    route: Curriculum._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$CurriculumToJson(Curriculum instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'timestamp': Curriculum._timestampToJson(instance.timestamp),
      'lang': instance.lang,
      'title': instance.title,
      'descPath': instance.descPath,
      'learnPath': instance.learnPath,
      'tags': instance.tags,
      'lessonsCount': instance.lessonsCount,
      'time': instance.time,
      'attachment': instance.attachment,
      'units': Curriculum.unitsToJson(instance.units),
      'humanPath': instance.humanPath,
      'route': Curriculum._routeToJson(instance.route),
    };
