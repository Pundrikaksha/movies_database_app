import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_database_app/presentation/bloc/home/home_bloc.dart';
import 'package:movies_database_app/presentation/bloc/home/home_event.dart';
import 'package:movies_database_app/presentation/bloc/home/home_state.dart';
import '../widgets/movie_poster.dart';
import '../widgets/shimmer_placeholder.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () => context.push('/search')),
          IconButton(icon: const Icon(Icons.bookmark, color: Colors.white), onPressed: () => context.push('/bookmarks')),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final featured =
              state.trending.isNotEmpty ? state.trending[0] : null;
    
          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(RefreshHomeEvent());
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: _buildHeader(context, featured, state.loading)),
                SliverToBoxAdapter(child: const SizedBox(height: 16)),
                SliverToBoxAdapter(
                    child: _Section(title: 'Trending Now', movies: state.trending)),
                SliverToBoxAdapter(child: const SizedBox(height: 16)),
                SliverToBoxAdapter(
                    child: _Section(title: 'Now Playing', movies: state.nowPlaying)),
                SliverToBoxAdapter(child: const SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }


Widget _buildHeader(BuildContext context, dynamic featured, bool loading) {
  if (loading && featured == null) {
    return SizedBox(
      height: 420,
      child: Center(
        child: ShimmerPlaceholder(
            width: 320, height: 420, borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
  if (featured == null) {
    return SizedBox(
      height: 420,
      child: Center(
          child: Text('No featured movie',
              style: Theme.of(context).textTheme.titleLarge)),
    );
  }

  return SizedBox(
    height: 420,
    child: Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Backdrop with cached image
        if (featured.backdropUrl.isNotEmpty)
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: featured.backdropUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[900]),
              errorWidget: (_, __, ___) =>
                  Container(color: Colors.grey[900], child: const Icon(Icons.broken_image, color: Colors.white54)),
            ),
          ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.3),
                Colors.transparent
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.0, 0.4, 0.9],
            ),
          ),
        ),

        // Poster and info
        Positioned(
          left: 16,
          bottom: 24,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                tag: 'poster_${featured.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 180,
                  
                    child: CachedNetworkImage(
                      imageUrl: featured.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[900]),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.broken_image, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(featured.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                        '${featured.releaseDate != null ? DateTime.tryParse(featured.releaseDate!)?.year.toString() ?? "N/A" : "N/A"} • ⭐ ${featured.voteAverage.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Text(
                      featured.overview ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.push('/movie/${featured.id}'),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/movie/${featured.id}'),
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Details'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
}

class _Section extends StatelessWidget {
  final String title;
  final List movies;
  const _Section({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: movies.isEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, __) => const SizedBox(
                    width: 140,
                    child: Center(
                        child: ShimmerPlaceholder(width: 120, height: 180)),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final m = movies[index];
                    return SizedBox(
                      width: 140,
                      child: MoviePoster(
                        movie: m,
                        onTap: () => context.push('/movie/${m.id}'),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: movies.length,
                ),
        ),
      ],
    );
  }
}
