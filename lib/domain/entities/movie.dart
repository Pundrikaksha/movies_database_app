import 'package:json_annotation/json_annotation.dart';
part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String title;
  final String? overview;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  final double popularity;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'release_date')
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.popularity,
    required this.voteAverage,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  String get posterUrl => posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';
  String get backdropUrl => backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : '';
}

@JsonSerializable()
class MoviesResponse {
  final List<Movie> results;
  MoviesResponse({required this.results});

  factory MoviesResponse.fromJson(Map<String, dynamic> json) => _$MoviesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);
}