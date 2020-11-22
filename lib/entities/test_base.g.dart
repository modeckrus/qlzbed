// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestBase _$TestBaseFromJson(Map<String, dynamic> json) {
  return TestBase(
    question: json['question'] as String,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TestBaseToJson(TestBase instance) => <String, dynamic>{
      'question': instance.question,
      'type': instance.type,
    };
