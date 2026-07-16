import 'package:flutter/foundation.dart';
import 'package:flutter_application/models/github_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_search_result.g.dart';

@immutable
@JsonSerializable()
class GithubSearchResult {
  const GithubSearchResult({
    required this.totalCount,
    required this.items,
  });

  @JsonKey(name: 'total_count')
  final int totalCount;
  final List<GithubRepository> items;

  factory GithubSearchResult.fromJson(Map<String, dynamic> json) =>
      _$GithubSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$GithubSearchResultToJson(this);

  GithubSearchResult copyWith({
    int? totalCount,
    List<GithubRepository>? items,
  }) {
    return GithubSearchResult(
      totalCount: totalCount ?? this.totalCount,
      items: items ?? this.items,
    );
  }
}
