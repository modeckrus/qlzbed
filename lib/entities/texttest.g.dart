// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'texttest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextTest _$TextTestFromJson(Map<String, dynamic> json) {
  return TextTest(
    question: json['question'] as String,
    answers: (json['answers'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TextTestToJson(TextTest instance) => <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
    };
