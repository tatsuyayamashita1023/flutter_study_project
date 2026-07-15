import 'package:flutter_application/models/news_article.dart';
import 'package:flutter_application/services/news_api_service.dart';
import 'package:flutter_application/services/news_bookmarks_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_provider.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'general';

  void select(String category) => state = category;
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
Future<List<NewsArticle>> newsArticles(NewsArticlesRef ref) async {
  final category = ref.watch(selectedCategoryProvider);
  return NewsApiService().fetchTopHeadlines(category: category);
}

@riverpod
Future<List<NewsArticle>> searchResults(SearchResultsRef ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return NewsApiService().searchArticles(query: query);
}

@riverpod
class Bookmarks extends _$Bookmarks {
  @override
  Future<List<NewsArticle>> build() async {
    return NewsBookmarksService().load();
  }

  Future<void> toggle(NewsArticle article) async {
    final current = await future;
    final isBookmarked = current.any((a) => a.url == article.url);
    final updated = isBookmarked
        ? current.where((a) => a.url != article.url).toList()
        : [...current, article];
    state = AsyncData(updated);
    await NewsBookmarksService().save(updated);
  }

  bool isBookmarked(List<NewsArticle> bookmarks, String url) =>
      bookmarks.any((a) => a.url == url);
}
