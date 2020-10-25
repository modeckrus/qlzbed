// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formula.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Formula _$FormulaFromJson(Map<String, dynamic> json) {
  return Formula(
    path: json['path'] as String,
    uid: json['uid'] as String,
    tex: json['tex'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$FormulaToJson(Formula instance) => <String, dynamic>{
      'path': instance.path,
      'uid': instance.uid,
      'tex': instance.tex,
      'tags': instance.tags,
      'title': instance.title,
    };
