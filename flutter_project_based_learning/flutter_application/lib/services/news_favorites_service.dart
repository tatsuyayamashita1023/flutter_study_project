import 'dart:convert';
import 'dart:io';

import 'package:flutter_application/models/news_article.dart';
import 'package:path_provider/path_provider.dart';

class NewsFavoritesService {
  static const String _fileName = 'news_favorites.json';

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<List<NewsArticle>> loadFavorites() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<NewsArticle> favorites) async {
    final file = await _getFile();
    await file.writeAsString(
      jsonEncode(favorites.map((e) => e.toJson()).toList()),
    );
  }
}
