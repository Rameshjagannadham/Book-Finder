import 'package:bloc_test/bloc_test.dart';
// import 'package:bookapp/features/book/domain/usecases/search_books.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookapp/features/book/presentation/bloc/search/search_books_bloc.dart';
import 'package:bookapp/features/book/domain/entities/book.dart';
import 'package:bookapp/features/book/domain/usecases/search_books.dart';

class MockSearchBooks extends Mock implements SearchBooks {}

void main() {
  late MockSearchBooks mockUsecase;
  late SearchBooksBloc bloc;

  setUp(() {
    mockUsecase = MockSearchBooks();
    bloc = SearchBooksBloc(mockUsecase);
  });

  tearDown(() => bloc.close());

  test('initial state', () {
    expect(bloc.state.status, SearchStatus.initial);
    expect(bloc.state.items, []);
  });

  blocTest<SearchBooksBloc, SearchBooksState>(
    'emits loading then success on query change',
    build: () {
      when(() => mockUsecase('harry', 1)).thenAnswer(
        (_) async =>
            ([const Book(key: '/works/OL1W', title: 'A', author: 'B')], 1),
      );
      return bloc;
    },
    act: (b) => b.add(const QueryChanged('harry')),
    expect: () => [
      isA<SearchBooksState>().having(
        (s) => s.status,
        'status',
        SearchStatus.loading,
      ),
      isA<SearchBooksState>()
          .having((s) => s.status, 'status', SearchStatus.success)
          .having((s) => s.items.length, 'len', 1),
    ],
  );
}
