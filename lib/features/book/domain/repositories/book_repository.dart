import '../entities/book.dart';

abstract class BookRepository {
  Future<(List<Book>, int total)> searchBooks(String query, int page);
  Future<(Book, Map<String, dynamic> details)> getBookWithDetails(
    String workKey,
  );
  Future<void> saveBook(Book book);
  Future<Book?> getSavedBook(String key);
  Future<void> deleteBook(String key);
}
