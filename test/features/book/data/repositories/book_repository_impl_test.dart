import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bookapp/features/book/data/repositories/book_repository_impl.dart';
import 'package:bookapp/features/book/data/datasources/book_remote_datasource.dart';
import 'package:bookapp/features/book/data/datasources/book_local_datasource.dart';
import 'package:bookapp/features/book/data/models/book_model.dart';

class MockRemote extends Mock implements BookRemoteDataSource {}

class MockLocal extends Mock implements BookLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late BookRepositoryImpl repo;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repo = BookRepositoryImpl(remote: remote, local: local);
  });

  test('searchBooks returns items + total', () async {
    when(() => remote.searchBooks(query: 'dart', page: 1)).thenAnswer(
      (_) async => (
        [
          const BookModel(
            key: '/works/OL1W',
            title: 'Dart',
            author: 'Gilad',
            coverId: 1,
          ),
        ],
        1,
      ),
    );

    final (items, total) = await repo.searchBooks('dart', 1);

    expect(items.length, 1);
    expect(total, 1);
  });
}
