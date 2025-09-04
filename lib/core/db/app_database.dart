import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _dbName = 'book_finder.db';
  static const _dbVersion = 1;

  static final AppDatabase _instance = AppDatabase._();
  AppDatabase._();
  factory AppDatabase() => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    _db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        key TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        coverId INTEGER,
        firstPublishYear INTEGER
      );
    ''');
  }
}
