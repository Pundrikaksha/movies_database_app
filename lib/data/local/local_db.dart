import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/movie.dart';
class LocalDb {
  static const _dbName = 'movie.db';
  static const _dbVersion = 1;

  static const tableTrending = 'trending';
  static const tableNowPlaying = 'now_playing';
  static const tableBookmarks = 'bookmarks';

  static Database? _db;

  static Future<LocalDb> getInstance() async {
    if (_db == null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, _dbName);
      _db = await openDatabase(
        path,
        version: _dbVersion,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $tableTrending(
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT,
              backdropPath TEXT,
              popularity REAL,
              voteAverage REAL,
              releaseDate TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE $tableNowPlaying(
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT,
              backdropPath TEXT,
              popularity REAL,
              voteAverage REAL,
              releaseDate TEXT
            );
          ''');
          await db.execute('''
            CREATE TABLE $tableBookmarks(
              id INTEGER PRIMARY KEY,
              title TEXT,
              overview TEXT,
              posterPath TEXT,
              backdropPath TEXT,
              popularity REAL,
              voteAverage REAL,
              releaseDate TEXT,
              addedAt INTEGER
            );
          ''');
        },
      );
    }
    return LocalDb();
  }

  Future<void> upsertList(String table, List<Movie> movies) async {
    final batch = _db!.batch();
    for (final m in movies) {
      batch.insert(
        table,
        {
          'id': m.id,
          'title': m.title,
          'overview': m.overview,
          'posterPath': m.posterPath,
          'backdropPath': m.backdropPath,
          'popularity': m.popularity,
          'voteAverage': m.voteAverage,
          'releaseDate': m.releaseDate,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Movie>> getList(String table) async {
    final rows = await _db!.query(table, orderBy: 'popularity DESC');
    return rows.map(_rowToMovie).toList();
  }

  Future<void> clearTable(String table) async {
    await _db!.delete(table);
  }

  Future<void> toggleBookmark(Movie m) async {
    final exists = await isBookmarked(m.id);
    if (exists) {
      await _db!.delete(tableBookmarks, where: 'id = ?', whereArgs: [m.id]);
    } else {
      await _db!.insert(tableBookmarks, {
        'id': m.id,
        'title': m.title,
        'overview': m.overview,
        'posterPath': m.posterPath,
        'backdropPath': m.backdropPath,
        'popularity': m.popularity,
        'voteAverage': m.voteAverage,
        'releaseDate': m.releaseDate,
        'addedAt': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<bool> isBookmarked(int id) async {
    final rows = await _db!.query(tableBookmarks, where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isNotEmpty;
  }

  Future<List<Movie>> getBookmarks() async {
    final rows = await _db!.query(tableBookmarks, orderBy: 'addedAt DESC');
    return rows.map(_rowToMovie).toList();
  }

  Movie _rowToMovie(Map<String, Object?> r) => Movie(
        id: r['id'] as int,
        title: r['title'] as String,
        overview: r['overview'] as String?,
        posterPath: r['posterPath'] as String?,
        backdropPath: r['backdropPath'] as String?,
        popularity: (r['popularity'] as num?)?.toDouble() ?? 0,
        voteAverage: (r['voteAverage'] as num?)?.toDouble() ?? 0,
        releaseDate: r['releaseDate'] as String?,
      );
}
