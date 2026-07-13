import 'package:flutter/material.dart';
import 'package:flutter_application/models/github_repository.dart';
import 'package:flutter_application/services/github_api_service.dart';

class GithubReposPage extends StatefulWidget {
  const GithubReposPage({super.key});

  @override
  State<GithubReposPage> createState() => _GithubReposPageState();
}

class _GithubReposPageState extends State<GithubReposPage> {
  final TextEditingController _controller = TextEditingController();
  final GithubApiService _apiService = GithubApiService();

  List<GithubRepository> _allItems = [];
  int _totalCount = 0;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  bool _hasSearched = false;

  bool get _hasMore => _allItems.length < _totalCount;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchRepositories() async {
    final String query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _allItems = [];
      _totalCount = 0;
      _currentPage = 1;
      _hasSearched = false;
    });

    try {
      final result = await _apiService.searchRepositories(query, page: 1);
      setState(() {
        _allItems = result.items;
        _totalCount = result.totalCount;
        _currentPage = 1;
        _isLoading = false;
        _hasSearched = true;
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

    final String query = _controller.text.trim();
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await _apiService.searchRepositories(
        query,
        page: _currentPage + 1,
      );
      setState(() {
        _allItems = [..._allItems, ...result.items];
        _currentPage += 1;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildBody() {
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
    if (!_hasSearched) {
      return const Center(child: Text('リポジトリ名を入力して検索してください'));
    }
    if (_allItems.isEmpty) {
      return const Center(child: Text('該当するリポジトリが見つかりませんでした'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '$_totalCount 件見つかりました（${_allItems.length} 件表示中）',
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _allItems.length + (_hasMore ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (index == _allItems.length) {
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
              final GithubRepository repo = _allItems[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(
                    repo.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (repo.description != null)
                        Text(repo.description!)
                      else
                        const Text(
                          '説明なし',
                          style: TextStyle(color: Colors.grey),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (repo.language != null) ...[
                            const Icon(Icons.circle,
                                size: 12, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(repo.language!),
                            const SizedBox(width: 12),
                          ],
                          const Icon(Icons.star_outline, size: 14),
                          const SizedBox(width: 2),
                          Text('${repo.stargazersCount}'),
                          const SizedBox(width: 12),
                          const Icon(Icons.fork_right, size: 14),
                          const SizedBox(width: 2),
                          Text('${repo.forksCount}'),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub リポジトリ検索'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'リポジトリ名で検索',
                      border: OutlineInputBorder(),
                      hintText: '例: flutter engine',
                    ),
                    onSubmitted: (_) => _searchRepositories(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _searchRepositories,
                  child: const Text('検索'),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
