import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_datasource.dart';
import '../datasources/book_remote_datasource.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remote;
  final BookLocalDataSource local;

  BookRepositoryImpl({required this.remote, required this.local});

  @override
  Future<(List<Book>, int total)> searchBooks(String query, int page) async {
    final (items, total) = await remote.searchBooks(query: query, page: page);
    return (items, total);
  }

  @override
  Future<(Book, Map<String, dynamic> details)> getBookWithDetails(
    String workKey,
  ) async {
    final details = await remote.getBookDetails(workKey);
    // minimal Book from details if needed; but the list provides Book already
    return (
      BookModel(
        key: workKey,
        title: details['title'] ?? 'Untitled',
        author:
            (details['authors'] is List &&
                (details['authors'] as List).isNotEmpty)
            ? ((details['authors'] as List).first['name'] ?? 'Unknown')
            : 'Unknown',
        coverId:
            (details['covers'] is List &&
                (details['covers'] as List).isNotEmpty)
            ? (details['covers'] as List).first as int
            : null,
        firstPublishYear: details['first_publish_date'] != null
            ? int.tryParse(
                (details['first_publish_date'] as String).split('-').first,
              )
            : null,
      ),
      details,
    );
  }

  @override
  Future<void> saveBook(Book book) async => local.saveBook(
    BookModel(
      key: book.key,
      title: book.title,
      author: book.author,
      coverId: book.coverId,
      firstPublishYear: book.firstPublishYear,
    ),
  );

  @override
  Future<Book?> getSavedBook(String key) async => await local.getBook(key);

  @override
  Future<void> deleteBook(String key) async => local.deleteBook(key);
}
