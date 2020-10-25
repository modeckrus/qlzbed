import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Equatable {
  final String path;
  final String uid;
  final List<String> tags;
  final String title;

  Article(
      {@required this.path,
      @required this.uid,
      @required this.tags,
      @required this.title});

  @override
  List<Object> get props => [path, uid, tags, title];

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
