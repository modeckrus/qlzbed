// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationGroup _$ModerationGroupFromJson(Map<String, dynamic> json) {
  return ModerationGroup(
    lang: json['lang'] as String,
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        ModerationGroup._timestamoFromJson(json['timestamp'] as Timestamp),
    humanPath: json['humanPath'] as String,
    isModerating: json['isModerating'] as bool,
    moderator: json['moderator'] as String,
    route: ModerationGroup._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationGroupToJson(ModerationGroup instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerationGroup._timestampToJson(instance.timestamp),
    'lang': instance.lang,
    'title': instance.title,
    'tags': instance.tags,
    'isModerating': instance.isModerating,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('moderator', instance.moderator);
  val['humanPath'] = instance.humanPath;
  val['route'] = ModerationGroup._routeToJson(instance.route);
  return val;
}
