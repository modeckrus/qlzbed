// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationUnit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationUnit _$ModerationUnitFromJson(Map<String, dynamic> json) {
  return ModerationUnit(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        ModerationUnit._timestamoFromJson(json['timestamp'] as Timestamp),
    humanPath: json['humanPath'] as String,
    isModerating: json['isModerating'] as bool,
    lessons: ModerationUnit.lessonsFromJson(json['lessons'] as List),
    moderator: json['moderator'] as String,
    route: ModerationUnit._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationUnitToJson(ModerationUnit instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerationUnit._timestampToJson(instance.timestamp),
    'lang': instance.lang,
    'title': instance.title,
    'tags': instance.tags,
    'lessons': ModerationUnit.lessonsToJson(instance.lessons),
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['route'] = ModerationUnit._routeToJson(instance.route);
  return val;
}
