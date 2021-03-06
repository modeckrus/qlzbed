// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
    timestamp: Article._timestamoFromJson(json['timestamp'] as Timestamp),
    lang: json['lang'] as String,
    route: Article._routeFromJson(json['route'] as String),
  );
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'path': instance.path,
      'uid': instance.uid,
      'tags': instance.tags,
      'title': instance.title,
      'lang': instance.lang,
      'timestamp': Article._timestampToJson(instance.timestamp),
      'route': Article._routeToJson(instance.route),
    };
