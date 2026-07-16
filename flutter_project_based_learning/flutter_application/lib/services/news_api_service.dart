import 'dart:convert';

import 'package:flutter_application/constants/api_keys.dart';
import 'package:flutter_application/models/news_article.dart';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsArticle>> fetchTopHeadlines({
    int page = 1,
    int pageSize = 20,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/top-headlines?country=us&page=$page&pageSize=$pageSize&apiKey=${ApiKeys.newsApi}',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawArticles = json['articles'] as List<dynamic>;
      return rawArticles
          .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
          .where((a) => a.title != '[Removed]')
          .toList();
    } else {
      throw Exception('APIエラー: ${response.statusCode}');
    }
  }
}
