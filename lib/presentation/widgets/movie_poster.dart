import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MoviePoster({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
           
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[900],
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[900],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Movie title
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
