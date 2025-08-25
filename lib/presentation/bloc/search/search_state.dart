
import 'package:movies_database_app/domain/entities/movie.dart';

class SearchState {
  final String query;
  final List<Movie> results;
  final bool loading;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.loading = false,
  });

  SearchState copyWith({
    String? query,
    List<Movie>? results,
    bool? loading,
  }) =>
      SearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        loading: loading ?? this.loading,
      );
}
