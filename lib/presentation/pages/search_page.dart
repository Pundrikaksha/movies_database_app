import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/search/search_cubit.dart';
import '../widgets/movie_poster.dart';
import '../widgets/shimmer_placeholder.dart';
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SearchCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (v) => context.read<SearchCubit>().onQueryChanged(v),
              decoration: InputDecoration(
                hintText: 'Search movies...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: state.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => context.read<SearchCubit>().onQueryChanged(''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFF1C1C1C),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          
          Expanded(
            child: state.loading
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.52,
                    ),
                    itemCount: 9,
                    itemBuilder: (_, __) => const ShimmerPlaceholder(width: 120, height: 180),
                  )
                : state.results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.movie_creation_outlined, size: 60, color: Colors.white54),
                            const SizedBox(height: 12),
                            Text(
                              state.query.isEmpty
                                  ? 'Start typing to search...'
                                  : 'No results for "${state.query}"',
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.52,
                        ),
                        itemCount: state.results.length,
                        itemBuilder: (_, i) {
                          final m = state.results[i];
                          return Hero(
                            tag: "movie_${m.id}",
                            child: MoviePoster(
                              movie: m,
                              onTap: () => context.push('/movie/${m.id}'),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
