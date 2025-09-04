part of 'search_books_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchBooksState extends Equatable {
  final SearchStatus status;
  final List<Book> items;
  final bool loadingMore;
  final bool reachedEnd;
  final String? error;

  const SearchBooksState({
    required this.status,
    required this.items,
    required this.loadingMore,
    required this.reachedEnd,
    this.error,
  });

  const SearchBooksState.initial()
    : status = SearchStatus.initial,
      items = const [],
      loadingMore = false,
      reachedEnd = false,
      error = null;

  SearchBooksState copyWith({
    SearchStatus? status,
    List<Book>? items,
    bool? loadingMore,
    bool? reachedEnd,
    String? error,
  }) => SearchBooksState(
    status: status ?? this.status,
    items: items ?? this.items,
    loadingMore: loadingMore ?? this.loadingMore,
    reachedEnd: reachedEnd ?? this.reachedEnd,
    error: error,
  );

  @override
  List<Object?> get props => [status, items, loadingMore, reachedEnd, error];
}
