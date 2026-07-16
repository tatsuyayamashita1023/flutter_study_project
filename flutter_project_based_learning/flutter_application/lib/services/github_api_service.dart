import 'dart:convert';

import 'package:flutter_application/models/github_search_result.dart';
import 'package:http/http.dart' as http;

class GithubApiService {
  static const String _baseUrl = 'https://api.github.com';

  Future<GithubSearchResult> searchRepositories(
    String query, {
    int page = 1,
    int perPage = 30,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/search/repositories?q=$query&per_page=$perPage&page=$page',
    );
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      return GithubSearchResult.fromJson(json);
    } else if (response.statusCode == 422) {
      throw Exception('検索キーワードが無効です');
    } else {
      throw Exception('APIエラー: ${response.statusCode}');
    }
  }
}
