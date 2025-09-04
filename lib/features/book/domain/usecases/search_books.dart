import '../entities/book.dart';
import '../repositories/book_repository.dart';

class SearchBooks {
  final BookRepository repo;
  SearchBooks(this.repo);

  Future<(List<Book>, int total)> call(String query, int page) =>
      repo.searchBooks(query, page);
}
