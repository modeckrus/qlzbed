// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationState _$ModerationStateFromJson(Map<String, dynamic> json) {
  return ModerationState(
    title: json['title'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    uid: json['uid'] as String,
    timestamp:
        ModerationState._timestamoFromJson(json['timestamp'] as Timestamp),
    humanPath: json['humanPath'] as String,
    isModerating: json['isModerating'] as bool,
    lang: json['lang'] as String,
    moderator: json['moderator'] as String,
    route: json['route'] as String,
  );
}

Map<String, dynamic> _$ModerationStateToJson(ModerationState instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'timestamp': ModerationState._timestampToJson(instance.timestamp),
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
  val['route'] = instance.route;
  val['lang'] = instance.lang;
  return val;
}
