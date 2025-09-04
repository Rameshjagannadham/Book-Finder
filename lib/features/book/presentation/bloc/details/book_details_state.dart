part of 'book_details_bloc.dart';

enum DetailsStatus { initial, loading, success, failure }

class BookDetailsState extends Equatable {
  final DetailsStatus status;
  final Book? book;
  final Map<String, dynamic>? details;
  final bool isSaved;
  final String? error;

  const BookDetailsState({
    required this.status,
    this.book,
    this.details,
    required this.isSaved,
    this.error,
  });

  const BookDetailsState.initial()
    : status = DetailsStatus.initial,
      book = null,
      details = null,
      isSaved = false,
      error = null;

  BookDetailsState copyWith({
    DetailsStatus? status,
    Book? book,
    Map<String, dynamic>? details,
    bool? isSaved,
    String? error,
  }) => BookDetailsState(
    status: status ?? this.status,
    book: book ?? this.book,
    details: details ?? this.details,
    isSaved: isSaved ?? this.isSaved,
    error: error,
  );

  @override
  List<Object?> get props => [status, book, details, isSaved, error];
}
