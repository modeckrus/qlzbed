// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckTest _$CheckTestFromJson(Map<String, dynamic> json) {
  return CheckTest(
    question: json['question'] as String,
    answers: (json['answers'] as List)
        ?.map((e) =>
            e == null ? null : Answer.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CheckTestToJson(CheckTest instance) => <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
    };
