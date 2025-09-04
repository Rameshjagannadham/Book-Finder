import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBookDetails {
  final BookRepository repo;
  GetBookDetails(this.repo);

  Future<(Book, Map<String, dynamic>)> call(String workKey) =>
      repo.getBookWithDetails(workKey);
}
