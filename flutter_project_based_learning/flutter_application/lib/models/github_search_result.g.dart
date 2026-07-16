// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubSearchResult _$GithubSearchResultFromJson(Map<String, dynamic> json) =>
    GithubSearchResult(
      totalCount: (json['total_count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => GithubRepository.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GithubSearchResultToJson(GithubSearchResult instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'items': instance.items,
    };
