import 'package:equatable/equatable.dart';
import 'package:movies_database_app/domain/entities/movie.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookmarksEvent extends BookmarksEvent {}
class RefreshBookmarksEvent extends BookmarksEvent {}
class ToggleBookmarkEvent extends BookmarksEvent {
  final Movie movie;
  const ToggleBookmarkEvent(this.movie);

  @override
  List<Object?> get props => [movie];
}
