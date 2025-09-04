part of 'search_books_bloc.dart';

sealed class SearchBooksEvent extends Equatable {
  const SearchBooksEvent();
  @override
  List<Object?> get props => [];
}

class QueryChanged extends SearchBooksEvent {
  final String query;
  const QueryChanged(this.query);
}

class FetchNextPage extends SearchBooksEvent {
  const FetchNextPage();
}

class Refresh extends SearchBooksEvent {
  const Refresh();
}

class RefreshBooks extends SearchBooksEvent {
  final String query;
  RefreshBooks(this.query);
}
