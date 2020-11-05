// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fstateMinimum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FStateMinimum _$FStateMinimumFromJson(Map<String, dynamic> json) {
  return FStateMinimum(
    title: json['title'] as String,
    uid: json['uid'] as String,
    timestamp: FStateMinimum._timestamoFromJson(json['timestamp'] as Timestamp),
    path: json['path'] as String,
    route: json['route'] as String,
  );
}

Map<String, dynamic> _$FStateMinimumToJson(FStateMinimum instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'timestamp': FStateMinimum._timestampToJson(instance.timestamp),
      'title': instance.title,
      'path': instance.path,
      'route': instance.route,
    };
