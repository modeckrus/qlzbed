// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationTextTest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationTextTest _$ModerationTextTestFromJson(Map<String, dynamic> json) {
  return ModerationTextTest(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp:
        ModerationTextTest._timestamoFromJson(json['timestamp'] as Timestamp),
    isModerating: json['isModerating'] as bool,
    humanPath: json['humanPath'] as String,
    lang: json['lang'] as String,
    answers: (json['answers'] as List)?.map((e) => e as String)?.toList(),
    moderator: json['moderator'] as String,
    route: ModerationTextTest._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationTextTestToJson(ModerationTextTest instance) {
  final val = <String, dynamic>{
    'path': instance.path,
    'uid': instance.uid,
    'tags': instance.tags,
    'answers': instance.answers,
    'title': instance.title,
    'timestamp': ModerationTextTest._timestampToJson(instance.timestamp),
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['lang'] = instance.lang;
  val['route'] = ModerationTextTest._routeToJson(instance.route);
  return val;
}
