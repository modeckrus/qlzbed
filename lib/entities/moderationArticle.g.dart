// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderationArticle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModerationArticle _$ModerationArticleFromJson(Map<String, dynamic> json) {
  return ModerationArticle(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp:
        ModerationArticle._timestamoFromJson(json['timestamp'] as Timestamp),
    isModerating: json['isModerating'] as bool,
    humanPath: json['humanPath'] as String,
    lang: json['lang'] as String,
    moderator: json['moderator'] as String,
    route: ModerationArticle._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ModerationArticleToJson(ModerationArticle instance) {
  final val = <String, dynamic>{
    'path': instance.path,
    'uid': instance.uid,
    'tags': instance.tags,
    'title': instance.title,
    'timestamp': ModerationArticle._timestampToJson(instance.timestamp),
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
  val['route'] = ModerationArticle._routeToJson(instance.route);
  return val;
}
