import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String key; // e.g. "/works/OL12345W"
  final String title;
  final String author;
  final int? coverId;
  final int? firstPublishYear;

  const Book({
    required this.key,
    required this.title,
    required this.author,
    this.coverId,
    this.firstPublishYear,
  });

  String? get coverUrl => coverId != null
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : null;

  @override
  List<Object?> get props => [key, title, author, coverId, firstPublishYear];
}
