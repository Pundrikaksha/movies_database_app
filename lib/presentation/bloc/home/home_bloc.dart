
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/movie_repository.dart';
import 'home_event.dart';
import 'home_state.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<LoadHomeEvent>(_onLoad);
    on<RefreshHomeEvent>(_onRefresh);
    on<RetryHomeEvent>(_onRetry);
  }

  Future<void> _onLoad(HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final results = await Future.wait([
        repo.fetchTrending(),
        repo.fetchNowPlaying(),
      ]);
      emit(state.copyWith(
        trending: results[0],
        nowPlaying: results[1],
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));

      final cachedT = await repo.getCachedTrending();
      final cachedN = await repo.getCachedNowPlaying();
      emit(state.copyWith(trending: cachedT, nowPlaying: cachedN));
    }
  }

  Future<void> _onRefresh(
      RefreshHomeEvent event, Emitter<HomeState> emit) async {
    add(LoadHomeEvent()); 
  }

  Future<void> _onRetry(
      RetryHomeEvent event, Emitter<HomeState> emit) async {
    add(LoadHomeEvent()); 
  }
}
