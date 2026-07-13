// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubRepository _$GithubRepositoryFromJson(Map<String, dynamic> json) =>
    GithubRepository(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      description: json['description'] as String?,
      stargazersCount: (json['stargazers_count'] as num).toInt(),
      language: json['language'] as String?,
      forksCount: (json['forks_count'] as num).toInt(),
      updatedAt: json['updated_at'] as String,
      htmlUrl: json['html_url'] as String,
    );

Map<String, dynamic> _$GithubRepositoryToJson(GithubRepository instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'description': instance.description,
      'stargazers_count': instance.stargazersCount,
      'language': instance.language,
      'forks_count': instance.forksCount,
      'updated_at': instance.updatedAt,
      'html_url': instance.htmlUrl,
    };
