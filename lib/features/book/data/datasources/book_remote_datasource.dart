import '../../../../core/network/api_client.dart';
import '../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<(List<BookModel>, int total)> searchBooks({
    required String query,
    required int page,
  });
  Future<Map<String, dynamic>> getBookDetails(String workKey);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final ApiClient client;
  BookRemoteDataSourceImpl(this.client);

  @override
  Future<(List<BookModel>, int total)> searchBooks({
    required String query,
    required int page,
  }) async {
    final json = await client.getJson(
      '/search.json',
      params: {'q': query, 'page': '$page'},
    );
    final docs = (json['docs'] as List).cast<Map<String, dynamic>>();
    final books = docs.map((e) => BookModel.fromSearchJson(e)).toList();
    final total = json['numFound'] as int? ?? books.length;
    return (books, total);
  }

  @override
  Future<Map<String, dynamic>> getBookDetails(String workKey) async {
    // workKey example: "/works/OL45883W"
    return client.getJson('$workKey.json');
  }
}
