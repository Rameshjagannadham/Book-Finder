import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.key,
    required super.title,
    required super.author,
    super.coverId,
    super.firstPublishYear,
  });

  factory BookModel.fromSearchJson(Map<String, dynamic> json) {
    final authors = (json['author_name'] as List?)?.cast<String>();
    return BookModel(
      key: (json['key'] as String?) ?? '',
      title: (json['title'] as String?) ?? 'Untitled',
      author: (authors != null && authors.isNotEmpty)
          ? authors.first
          : 'Unknown',
      coverId: json['cover_i'] as int?,
      firstPublishYear: json['first_publish_year'] as int?,
    );
  }

  Map<String, dynamic> toDbMap() => {
    'key': key,
    'title': title,
    'author': author,
    'coverId': coverId,
    'firstPublishYear': firstPublishYear,
  };

  factory BookModel.fromDb(Map<String, dynamic> map) => BookModel(
    key: map['key'] as String,
    title: map['title'] as String,
    author: map['author'] as String,
    coverId: map['coverId'] as int?,
    firstPublishYear: map['firstPublishYear'] as int?,
  );
}
