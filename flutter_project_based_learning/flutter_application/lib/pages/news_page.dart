import 'package:flutter/material.dart';
import 'package:flutter_application/models/news_article.dart';
import 'package:flutter_application/pages/news_detail_page.dart';
import 'package:flutter_application/services/news_api_service.dart';
import 'package:flutter_application/services/news_favorites_service.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final NewsApiService _apiService = NewsApiService();
  final NewsFavoritesService _favoritesService = NewsFavoritesService();

  List<NewsArticle> _articles = [];
  List<NewsArticle> _favorites = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final favorites = await _favoritesService.loadFavorites();
    if (mounted) {
      setState(() {
        _favorites = favorites;
      });
    }
    await _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _articles = [];
      _currentPage = 1;
      _hasMore = true;
    });
    try {
      final articles = await _apiService.fetchTopHeadlines(page: 1);
      setState(() {
        _articles = articles;
        _hasMore = articles.length >= 20;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final articles = await _apiService.fetchTopHeadlines(
        page: _currentPage + 1,
      );
      setState(() {
        _articles = [..._articles, ...articles];
        _currentPage += 1;
        _hasMore = articles.length >= 20;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _toggleFavorite(NewsArticle article) async {
    final isFav = _favorites.any((f) => f.url == article.url);
    final List<NewsArticle> updated;
    if (isFav) {
      updated = _favorites.where((f) => f.url != article.url).toList();
    } else {
      updated = [..._favorites, article];
    }
    setState(() {
      _favorites = updated;
    });
    await _favoritesService.save(updated);
  }

  bool _isFavorite(String url) => _favorites.any((f) => f.url == url);

  String _formatDate(String publishedAt) {
    if (publishedAt.length < 10) return publishedAt;
    return publishedAt.substring(0, 10);
  }

  Future<void> _navigateToDetail(NewsArticle article) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => NewsDetailPage(
          article: article,
          isFavorite: _isFavorite(article.url),
          onFavoriteToggle: () => _toggleFavorite(article),
        ),
      ),
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    final isFav = _isFavorite(article.url);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetail(article),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(article.publishedAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () => _toggleFavorite(article),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_articles.isEmpty) {
      return const Center(child: Text('記事がありません'));
    }
    return RefreshIndicator(
      onRefresh: _fetchNews,
      child: ListView.builder(
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _articles.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: _isLoadingMore
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _loadMore,
                        child: const Text('もっと読み込む'),
                      ),
              ),
            );
          }
          return _buildArticleCard(_articles[index]);
        },
      ),
    );
  }

  Widget _buildFavoritesList() {
    if (_favorites.isEmpty) {
      return const Center(child: Text('お気に入りはまだありません'));
    }
    return ListView.builder(
      itemCount: _favorites.length,
      itemBuilder: (context, index) => _buildArticleCard(_favorites[index]),
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
            Tab(text: 'お気に入り'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewsList(),
          _buildFavoritesList(),
        ],
      ),
    );
  }
}
