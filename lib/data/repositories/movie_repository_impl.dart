import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../remote/tmdb_api.dart';
import '../local/local_db.dart';
class MovieRepositoryImpl implements MovieRepository {
  final TmdbApi api;
  final LocalDb db;
  final Connectivity connectivity;

  MovieRepositoryImpl({
    required this.api,
    required this.db,
    required this.connectivity,
  });


  Future<bool> _online() async =>
      (await connectivity.checkConnectivity()) != ConnectivityResult.none;

  @override
  Future<List<Movie>> fetchTrending({int page = 1}) async {
    if (await _online()) {
      final response = await api.trending(page);
      final list = response.results;
      if (page == 1) await db.clearTable(LocalDb.tableTrending);
      await db.upsertList(LocalDb.tableTrending, list);
      return list;
    }
    return db.getList(LocalDb.tableTrending);
  }

  @override
  Future<List<Movie>> fetchNowPlaying({int page = 1}) async {
    if (await _online()) {
      final response = await api.nowPlaying(page, 'IN');
      final list = response.results;
      if (page == 1) await db.clearTable(LocalDb.tableNowPlaying);
      await db.upsertList(LocalDb.tableNowPlaying, list);
      return list;
    }
    return db.getList(LocalDb.tableNowPlaying);
  }

  @override
  Future<Movie?> fetchDetails(int id) async {
   

    final allMovies = await Future.wait([
      db.getList(LocalDb.tableTrending),
      db.getList(LocalDb.tableNowPlaying),
      db.getBookmarks(),
    ]);
    final cache = allMovies.expand((e) => e).toList();
    try {
      return cache.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
Future<List<Movie>> search(String query, {int page = 1}) async {
  if (!await _online()) {
    final allMovies = await Future.wait([
      db.getList(LocalDb.tableTrending),
      db.getList(LocalDb.tableNowPlaying),
      db.getBookmarks(),
    ]);
    final cache = allMovies.expand((e) => e).toList();

    return cache
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList()
      ..sort((a, b) => b.popularity.compareTo(a.popularity)); // optional: sort
  }

  final response = await api.search(query, page, false);
  if (page == 1) {
    await db.upsertList(LocalDb.tableTrending, response.results);
  }

  return response.results;
}

  @override
  Future<void> toggleBookmark(Movie movie) => db.toggleBookmark(movie);

  @override
  Future<bool> isBookmarked(int movieId) => db.isBookmarked(movieId);

  @override
  Future<List<Movie>> getBookmarks() => db.getBookmarks();

  @override
  Future<List<Movie>> getCachedTrending() => db.getList(LocalDb.tableTrending);

  @override
  Future<List<Movie>> getCachedNowPlaying() => db.getList(LocalDb.tableNowPlaying);
}
