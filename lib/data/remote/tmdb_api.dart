import 'package:dio/dio.dart';
import 'package:movies_database_app/domain/entities/movie.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


part 'tmdb_api.g.dart';
@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApi {
  factory TmdbApi(Dio dio, {String baseUrl}) = _TmdbApi;

  @GET('trending/movie/day')
  Future<MoviesResponse> trending(@Query('page') int page);

  @GET('movie/now_playing')
  Future<MoviesResponse> nowPlaying(@Query('page') int page, @Query('region') String region);

  @GET('movie/{id}')
  Future<Movie> details(@Path('id') int id);

  @GET('search/movie')
  Future<MoviesResponse> search(
      @Query('query') String query,
      @Query('page') int page,
      @Query('include_adult') bool includeAdult);
}
