import 'package:movies_database_app/domain/entities/movie.dart';
class DetailsState {
  final Movie? movie;
  final bool loading;
  final bool bookmarked;
  const DetailsState({this.movie, this.loading = false, this.bookmarked = false});

  DetailsState copyWith({Movie? movie, bool? loading, bool? bookmarked}) =>
      DetailsState(movie: movie ?? this.movie, loading: loading ?? this.loading, bookmarked: bookmarked ?? this.bookmarked);
}

