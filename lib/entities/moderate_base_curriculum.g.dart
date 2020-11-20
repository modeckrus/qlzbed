// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderate_base_curriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerateBaseCurriculum _$ModerateBaseCurriculumFromJson(
    Map<String, dynamic> json) {
  return ModerateBaseCurriculum(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp: ModerateBaseCurriculum._timestamoFromJson(
        json['timestamp'] as Timestamp),
    time: json['time'] as int,
    isModerating: json['isModerating'] as bool,
    humanPath: json['humanPath'] as String,
    moderator: json['moderator'] as String,
    route: ModerateBaseCurriculum._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerateBaseCurriculumToJson(
    ModerateBaseCurriculum instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerateBaseCurriculum._timestampToJson(instance.timestamp),
    'lang': instance.lang,
    'title': instance.title,
    'tags': instance.tags,
    'time': instance.time,
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['route'] = ModerateBaseCurriculum._routeToJson(instance.route);
  return val;
}
