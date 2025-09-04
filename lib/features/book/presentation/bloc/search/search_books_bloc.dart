import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/usecases/search_books.dart';

part 'search_books_event.dart';
part 'search_books_state.dart';

class SearchBooksBloc extends Bloc<SearchBooksEvent, SearchBooksState> {
  final SearchBooks searchBooks;

  SearchBooksBloc(this.searchBooks) : super(const SearchBooksState.initial()) {
    on<QueryChanged>(_onQueryChanged);
    on<FetchNextPage>(_onFetchNextPage);
    on<Refresh>(_onRefresh);
  }

  String _currentQuery = '';
  int _page = 1;
  int _total = 0;

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<SearchBooksState> emit,
  ) async {
    _currentQuery = event.query.trim();
    if (_currentQuery.isEmpty) {
      emit(const SearchBooksState.initial());
      return;
    }
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        items: [],
        error: null,
        reachedEnd: false,
      ),
    );
    _page = 1;
    try {
      final (items, total) = await searchBooks(_currentQuery, _page);
      _total = total;
      emit(
        state.copyWith(
          status: SearchStatus.success,
          items: items,
          reachedEnd: items.length >= total,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onFetchNextPage(
    FetchNextPage event,
    Emitter<SearchBooksState> emit,
  ) async {
    if (state.status != SearchStatus.success ||
        state.loadingMore ||
        state.reachedEnd)
      return;
    if (_currentQuery.isEmpty) return;
    emit(state.copyWith(loadingMore: true));
    try {
      _page += 1;
      final (items, _) = await searchBooks(_currentQuery, _page);
      final all = List<Book>.from(state.items)..addAll(items);
      emit(
        state.copyWith(
          items: all,
          loadingMore: false,
          reachedEnd: all.length >= _total,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }

  Future<void> _onRefresh(Refresh event, Emitter<SearchBooksState> emit) async {
    if (_currentQuery.isEmpty) return;
    add(QueryChanged(_currentQuery));
  }
}
