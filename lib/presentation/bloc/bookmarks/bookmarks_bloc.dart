import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_event.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_state.dart';
import '../../../domain/repositories/movie_repository.dart';
class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final MovieRepository repo;
  BookmarksBloc(this.repo) : super(const BookmarksState()) {
    on<LoadBookmarksEvent>(_onLoad);
    on<RefreshBookmarksEvent>(_onRefresh);
    on<ToggleBookmarkEvent>(_onToggle);
  }

  Future<void> _onLoad(
      LoadBookmarksEvent event, Emitter<BookmarksState> emit) async {
    emit(state.copyWith(loading: true));
    final list = await repo.getBookmarks();
    emit(state.copyWith(movies: list, loading: false));
  }

  Future<void> _onRefresh(
      RefreshBookmarksEvent event, Emitter<BookmarksState> emit) async {
    await _onLoad(LoadBookmarksEvent(), emit);
  }

  Future<void> _onToggle(
      ToggleBookmarkEvent event, Emitter<BookmarksState> emit) async {
    await repo.toggleBookmark(event.movie);
    await _onLoad(LoadBookmarksEvent(), emit);
  }
}
