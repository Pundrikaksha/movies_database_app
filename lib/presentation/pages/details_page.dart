import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_bloc.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_event.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/details/detail_state.dart';

import 'package:cached_network_image/cached_network_image.dart';

class DetailsPage extends StatelessWidget {
  final int movieId;
  const DetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    context.read<DetailsBloc>().add(LoadDetails(movieId));

    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final movie = state.movie;

        if (state.loading || movie == null) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: Colors.black,
                leading: const BackButton(color: Colors.white),
                actions: [
                  IconButton(
                    icon: Icon(
                      state.bookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        context.read<DetailsBloc>().add(ToggleBookmark()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      final link = 'movies_database_app://movie/$movieId';
                      Share.share('Check this movie: $link');
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (movie.backdropUrl.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: movie.backdropUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: Colors.black26),
                          errorWidget: (_, __, ___) =>
                              const Icon(Icons.broken_image, color: Colors.white70),
                        ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black87, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie poster + details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'poster_${movie.id}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: movie.posterUrl,
                                height: 180,
                                width: 120,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    color: Colors.black26, width: 120, height: 180),
                                errorWidget: (_, __, ___) => const Icon(
                                    Icons.broken_image, color: Colors.white70, size: 60),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                               
                                    '${movie.releaseDate != null ? DateTime.tryParse(movie.releaseDate!)?.year.toString() ?? "N/A" : "N/A"} • ⭐ ${movie.voteAverage != null ? movie.voteAverage!.toStringAsFixed(1) : "N/A"}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        icon: const Icon(Icons.play_arrow),
                                        label: const Text("Play"),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(color: Colors.white54),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        icon: const Icon(Icons.add),
                                        label: const Text("My List"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview ?? "No overview available",
                        style: const TextStyle(color: Colors.white70, height: 1.5),
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 16),
                      const Text(
                        "More like this",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: movie.posterUrl,
                                width: 110,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: Colors.black26, width: 110),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.broken_image, color: Colors.white70),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
