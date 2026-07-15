import 'package:flutter/material.dart';
import 'package:flutter_application/models/news_article.dart';
import 'package:flutter_application/pages/news_detail_page.dart';
import 'package:flutter_application/providers/news_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<Map<String, String>> _categories = [
  {'label': 'General', 'value': 'general'},
  {'label': 'Business', 'value': 'business'},
  {'label': 'Entertainment', 'value': 'entertainment'},
  {'label': 'Health', 'value': 'health'},
  {'label': 'Science', 'value': 'science'},
  {'label': 'Sports', 'value': 'sports'},
  {'label': 'Technology', 'value': 'technology'},
];

class NewsPage extends ConsumerStatefulWidget {
  const NewsPage({super.key});

  @override
  ConsumerState<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends ConsumerState<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).update(value);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).update('');
    setState(() {});
  }

  String _formatDate(String publishedAt) {
    if (publishedAt.length < 10) return publishedAt;
    return publishedAt.substring(0, 10);
  }

  Widget _buildArticleCard(NewsArticle article, List<NewsArticle> bookmarks) {
    final isBookmarked = ref
        .read(bookmarksProvider.notifier)
        .isBookmarked(bookmarks, article.url);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (_) => NewsDetailPage(article: article),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => const SizedBox.shrink(),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            if (article.description != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  article.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 4, 4),
              child: Row(
                children: [
                  Text(
                    article.source.name,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(article.publishedAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () =>
                        ref.read(bookmarksProvider.notifier).toggle(article),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    final searchQuery = ref.watch(searchQueryProvider);
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final bookmarks = bookmarksAsync.valueOrNull ?? [];

    if (searchQuery.isNotEmpty) {
      final searchAsync = ref.watch(searchResultsProvider);
      return searchAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              e.toString(),
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('該当する記事が見つかりませんでした'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) =>
                _buildArticleCard(articles[index], bookmarks),
          );
        },
      );
    }

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final newsAsync = ref.watch(newsArticlesProvider);

    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat['value'] == selectedCategory;
              return ChoiceChip(
                label: Text(cat['label']!),
                selected: isSelected,
                onSelected: (_) => ref
                    .read(selectedCategoryProvider.notifier)
                    .select(cat['value']!),
              );
            },
          ),
        ),
        Expanded(
          child: newsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (articles) {
              if (articles.isEmpty) {
                return const Center(child: Text('記事がありません'));
              }
              return RefreshIndicator(
                onRefresh: () async =>
                    ref.refresh(newsArticlesProvider.future),
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) =>
                      _buildArticleCard(articles[index], bookmarks),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarksList() {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    return bookmarksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (bookmarks) {
        if (bookmarks.isEmpty) {
          return const Center(child: Text('ブックマークはまだありません'));
        }
        return ListView.builder(
          itemCount: bookmarks.length,
          itemBuilder: (context, index) =>
              _buildArticleCard(bookmarks[index], bookmarks),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ニュース'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ニュース一覧'),
            Tab(text: 'ブックマーク'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'キーワードで検索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNewsList(),
                _buildBookmarksList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
