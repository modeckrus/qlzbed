// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationTests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationTests _$ModerationTestsFromJson(Map<String, dynamic> json) {
  return ModerationTests(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp:
        ModerationTests._timestamoFromJson(json['timestamp'] as Timestamp),
    isModerating: json['isModerating'] as bool,
    humanPath: json['humanPath'] as String,
    lang: json['lang'] as String,
    tests: (json['tests'] as List)
        ?.map((e) =>
            e == null ? null : TestBase.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    moderator: json['moderator'] as String,
    route: ModerationTests._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationTestsToJson(ModerationTests instance) {
  final val = <String, dynamic>{
    'path': instance.path,
    'uid': instance.uid,
    'tags': instance.tags,
    'title': instance.title,
    'timestamp': ModerationTests._timestampToJson(instance.timestamp),
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
  val['tests'] = instance.tests;
  val['route'] = ModerationTests._routeToJson(instance.route);
  return val;
}
