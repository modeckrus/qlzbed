// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationLesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationLesson _$ModerationLessonFromJson(Map<String, dynamic> json) {
  return ModerationLesson(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        ModerationLesson._timestamoFromJson(json['timestamp'] as Timestamp),
    humanPath: json['humanPath'] as String,
    isModerating: json['isModerating'] as bool,
    states: ModerationLesson.statesFromJson(json['states'] as List),
    moderator: json['moderator'] as String,
    route: ModerationLesson._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationLessonToJson(ModerationLesson instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerationLesson._timestampToJson(instance.timestamp),
    'lang': instance.lang,
    'title': instance.title,
    'tags': instance.tags,
    'states': ModerationLesson.statesToJson(instance.states),
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['route'] = ModerationLesson._routeToJson(instance.route);
  return val;
}
