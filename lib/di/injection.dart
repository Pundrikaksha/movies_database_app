import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_bloc.dart';
import 'package:movies_database_app/presentation/bloc/home/home_bloc.dart';
import 'package:movies_database_app/presentation/bloc/search/search_cubit.dart';
import '../core/network/interceptors/tmdb_api_key_interceptor.dart';
import '../data/remote/tmdb_api.dart';
import '../data/local/local_db.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Dio + Interceptor
  final dio = Dio();
  dio.interceptors.add(TmdbApiKeyInterceptor());
  dio.interceptors.add(LogInterceptor(responseBody: false, requestBody: false));

  //  API
  final api = TmdbApi(dio);

  // Local DB
  final db = await LocalDb.getInstance();

  // Repository
  final repo = MovieRepositoryImpl(api: api, db: db, connectivity: Connectivity());

  // Register
  getIt.registerSingleton<MovieRepository>(repo);
  // Register Blocs
  getIt.registerFactory(() => HomeBloc(repo));
  getIt.registerFactory(() => BookmarksBloc(repo));
  getIt.registerFactory(() => SearchCubit(repo));
  getIt.registerFactory(() => DetailsBloc(repo));
}
