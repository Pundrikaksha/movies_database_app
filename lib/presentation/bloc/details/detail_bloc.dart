import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_database_app/domain/repositories/movie_repository.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_event.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_state.dart';
// replace with your repo

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final MovieRepository repo;

  DetailsBloc(this.repo) : super(const DetailsState()) {
    on<LoadDetails>(_onLoadDetails);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onLoadDetails(LoadDetails event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(loading: true,
    //  error: null
     ));

    try {
      final movie = await repo.fetchDetails(event.movieId);
      final bm = await repo.isBookmarked(event.movieId);
      emit(state.copyWith(movie: movie, loading: false, bookmarked: bm));
    } catch (e) {
      emit(state.copyWith(loading: false, 
      // error: e.toString()
      ));
    }
  }

  Future<void> _onToggleBookmark(ToggleBookmark event, Emitter<DetailsState> emit) async {
    final movie = state.movie;
    if (movie == null) return;

    await repo.toggleBookmark(movie);
    final bm = await repo.isBookmarked(movie.id);
    emit(state.copyWith(bookmarked: bm));
  }
}
