import 'package:flutter/material.dart';
import 'package:flutter_application/models/news_article.dart';
import 'package:flutter_application/providers/news_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends ConsumerWidget {
  const NewsDetailPage({super.key, required this.article});

  final NewsArticle article;

  String _formatDate(String publishedAt) {
    if (publishedAt.length < 10) return publishedAt;
    return publishedAt.substring(0, 10);
  }

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(article.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URLを開けませんでした')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final bookmarks = bookmarksAsync.valueOrNull ?? [];
    final isBookmarked = ref
        .read(bookmarksProvider.notifier)
        .isBookmarked(bookmarks, article.url);

    return Scaffold(
      appBar: AppBar(
        title: const Text('記事詳細'),
        actions: [
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => const SizedBox.shrink(),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        article.source.name,
                        style: const TextStyle(
                            color: Colors.blue, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(article.publishedAt),
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  if (article.author != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '著者：${article.author}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                  const Divider(height: 24),
                  if (article.description != null) ...[
                    Text(
                      article.description!,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (article.content != null) ...[
                    Text(
                      article.content!,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('記事全文を読む'),
                      onPressed: () => _launchUrl(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
