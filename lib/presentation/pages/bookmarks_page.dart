import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_event.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_state.dart';
import '../bloc/bookmarks/bookmarks_bloc.dart';
import '../widgets/movie_poster.dart';
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BookmarksBloc>().add(LoadBookmarksEvent());

    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Saved Movies')),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<BookmarksBloc>().add(RefreshBookmarksEvent());
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.52,
                    ),
                    itemCount: state.movies.length,
                    itemBuilder: (_, i) {
                      final m = state.movies[i];
                      return MoviePoster(
                        movie: m,
                        onTap: () => context.push('/movie/${m.id}'),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
