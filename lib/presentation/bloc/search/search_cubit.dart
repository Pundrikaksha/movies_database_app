import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_database_app/presentation/bloc/search/search_state.dart';
import '../../../domain/repositories/movie_repository.dart';
class SearchCubit extends Cubit<SearchState> {
  final MovieRepository repo;
  Timer? _debounce;

  SearchCubit(this.repo) : super(const SearchState());

  void onQueryChanged(String q) {
    emit(state.copyWith(query: q));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (q.trim().isEmpty) {
        emit(state.copyWith(results: []));
        return;
      }
      emit(state.copyWith(loading: true));
      final r = await repo.search(q);
      emit(state.copyWith(results: r, loading: false));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
