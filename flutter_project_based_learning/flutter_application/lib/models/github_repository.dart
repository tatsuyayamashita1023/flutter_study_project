import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github_repository.g.dart';

@immutable
@JsonSerializable()
class GithubRepository {
  const GithubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.stargazersCount,
    this.language,
    required this.forksCount,
    required this.updatedAt,
    required this.htmlUrl,
  });

  final int id;
  final String name;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? description;
  @JsonKey(name: 'stargazers_count')
  final int stargazersCount;
  final String? language;
  @JsonKey(name: 'forks_count')
  final int forksCount;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'html_url')
  final String htmlUrl;

  factory GithubRepository.fromJson(Map<String, dynamic> json) =>
      _$GithubRepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$GithubRepositoryToJson(this);

  GithubRepository copyWith({
    int? id,
    String? name,
    String? fullName,
    String? description,
    int? stargazersCount,
    String? language,
    int? forksCount,
    String? updatedAt,
    String? htmlUrl,
  }) {
    return GithubRepository(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      description: description ?? this.description,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      language: language ?? this.language,
      forksCount: forksCount ?? this.forksCount,
      updatedAt: updatedAt ?? this.updatedAt,
      htmlUrl: htmlUrl ?? this.htmlUrl,
    );
  }
}
