import 'package:equatable/equatable.dart';
import 'package:movies_database_app/domain/entities/movie.dart';

class BookmarksState extends Equatable {
  final List<Movie> movies;
  final bool loading;
  const BookmarksState({this.movies = const [], this.loading = false});

  BookmarksState copyWith({List<Movie>? movies, bool? loading}) =>
      BookmarksState(
        movies: movies ?? this.movies,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [movies, loading];
}
