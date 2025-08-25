abstract class DetailsEvent {}

class LoadDetails extends DetailsEvent {
  final int movieId;
  LoadDetails(this.movieId);
}

class ToggleBookmark extends DetailsEvent {}
