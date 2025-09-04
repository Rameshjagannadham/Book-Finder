import 'package:sqflite/sqflite.dart';
import '../../../../core/db/app_database.dart';
import '../models/book_model.dart';

abstract class BookLocalDataSource {
  Future<void> saveBook(BookModel book);
  Future<void> deleteBook(String key);
  Future<BookModel?> getBook(String key);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  Future<Database> get _db async => AppDatabase().database;

  @override
  Future<void> saveBook(BookModel book) async {
    final db = await _db;
    await db.insert(
      'books',
      book.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteBook(String key) async {
    final db = await _db;
    await db.delete('books', where: 'key = ?', whereArgs: [key]);
  }

  @override
  Future<BookModel?> getBook(String key) async {
    final db = await _db;
    final maps = await db.query(
      'books',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BookModel.fromDb(maps.first);
  }
}
