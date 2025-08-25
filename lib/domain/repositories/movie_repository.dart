import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchTrending({int page = 1});
  Future<List<Movie>> fetchNowPlaying({int page = 1});
  Future<Movie?> fetchDetails(int id);
  Future<List<Movie>> search(String query, {int page = 1});

  // Bookmarks
  Future<void> toggleBookmark(Movie movie);
  Future<bool> isBookmarked(int movieId);
  Future<List<Movie>> getBookmarks();

  // Local cached lists
  Future<List<Movie>> getCachedTrending();
  Future<List<Movie>> getCachedNowPlaying();
}
