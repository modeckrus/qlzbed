// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationCurriculum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationCurriculum _$ModerationCurriculumFromJson(Map<String, dynamic> json) {
  return ModerationCurriculum(
    lessons: ModerationCurriculum.lessonsFromJson(json['lessons'] as List),
    descPath: json['descPath'] as String,
    lessonsCount: json['lessonsCount'] as int,
    time: json['time'] as int,
    learns: (json['learns'] as List)?.map((e) => e as String)?.toList(),
    requirments:
        (json['requirments'] as List)?.map((e) => e as String)?.toList(),
    shortDesc: json['shortDesc'] as String,
    attachment: (json['attachment'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ModerationCurriculumToJson(
        ModerationCurriculum instance) =>
    <String, dynamic>{
      'descPath': instance.descPath,
      'learns': instance.learns,
      'requirments': instance.requirments,
      'lessonsCount': instance.lessonsCount,
      'time': instance.time,
      'attachment': instance.attachment,
      'lessons': ModerationCurriculum.lessonsToJson(instance.lessons),
      'shortDesc': instance.shortDesc,
    };
