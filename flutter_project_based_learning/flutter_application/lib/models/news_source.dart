import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_source.g.dart';

@immutable
@JsonSerializable()
class NewsSource {
  const NewsSource({
    this.id,
    required this.name,
  });

  final String? id;
  final String name;

  factory NewsSource.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceFromJson(json);

  Map<String, dynamic> toJson() => _$NewsSourceToJson(this);

  NewsSource copyWith({
    String? id,
    String? name,
  }) {
    return NewsSource(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
