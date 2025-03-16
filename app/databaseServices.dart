import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'MovieModel.dart';
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE movies (
            id TEXT PRIMARY KEY,
            title TEXT,
            language TEXT,
            year INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertMovie(MovieModel movie) async {
    final db = await database;
    await db.insert('movies', movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> editMovie(MovieModel movie) async {
    final db = await database;
    await db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<void> deleteMovie(String id) async {
    final db = await database;
    await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MovieModel>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Movies');
    return List.generate(maps.length, (i) {
      return MovieModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        language: maps[i]['language'],
        year: maps[i]['year'],
      );
    });
  }
}
