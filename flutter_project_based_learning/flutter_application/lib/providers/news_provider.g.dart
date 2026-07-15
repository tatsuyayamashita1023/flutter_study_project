// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsArticlesHash() => r'564b14dc96c067a19015fcdb248c1283df52e60b';

/// See also [newsArticles].
@ProviderFor(newsArticles)
final newsArticlesProvider =
    AutoDisposeFutureProvider<List<NewsArticle>>.internal(
  newsArticles,
  name: r'newsArticlesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$newsArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewsArticlesRef = AutoDisposeFutureProviderRef<List<NewsArticle>>;
String _$searchResultsHash() => r'06933ded8ed49f46cfd8d165bbbcee95e5395c19';

/// See also [searchResults].
@ProviderFor(searchResults)
final searchResultsProvider =
    AutoDisposeFutureProvider<List<NewsArticle>>.internal(
  searchResults,
  name: r'searchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchResultsRef = AutoDisposeFutureProviderRef<List<NewsArticle>>;
String _$selectedCategoryHash() => r'87510bb73ce71a831792856d9a9b410dd93fbe4a';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$bookmarksHash() => r'71db7a7a8a4a2eb0535ef987549090fd2945dd6b';

/// See also [Bookmarks].
@ProviderFor(Bookmarks)
final bookmarksProvider =
    AutoDisposeAsyncNotifierProvider<Bookmarks, List<NewsArticle>>.internal(
  Bookmarks.new,
  name: r'bookmarksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$bookmarksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Bookmarks = AutoDisposeAsyncNotifier<List<NewsArticle>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
