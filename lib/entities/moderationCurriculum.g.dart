// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationCurriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationCurriculum _$ModerationCurriculumFromJson(Map<String, dynamic> json) {
  return ModerationCurriculum(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        ModerationCurriculum._timestamoFromJson(json['timestamp'] as Timestamp),
    units: ModerationCurriculum.unitsFromJson(json['units'] as List),
    descPath: json['descPath'] as String,
    learnPath: json['learnPath'] as String,
    lessonsCount: json['lessonsCount'] as int,
    time: json['time'] as int,
    humanPath: json['humanPath'] as String,
    isModerating: json['isModerating'] as bool,
    moderator: json['moderator'] as String,
    attachment: (json['attachment'] as List)?.map((e) => e as String)?.toList(),
    route: ModerationCurriculum._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationCurriculumToJson(
    ModerationCurriculum instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerationCurriculum._timestampToJson(instance.timestamp),
    'lang': instance.lang,
    'title': instance.title,
    'descPath': instance.descPath,
    'learnPath': instance.learnPath,
    'tags': instance.tags,
    'lessonsCount': instance.lessonsCount,
    'time': instance.time,
    'attachment': instance.attachment,
    'units': ModerationCurriculum.unitsToJson(instance.units),
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['route'] = ModerationCurriculum._routeToJson(instance.route);
  return val;
}
