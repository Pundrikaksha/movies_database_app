import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:movies_database_app/presentation/bloc/bookmarks/bookmarks_event.dart';
import 'package:movies_database_app/presentation/bloc/details/detail_bloc.dart';
import 'package:movies_database_app/presentation/bloc/home/home_bloc.dart';
import 'package:movies_database_app/presentation/bloc/home/home_event.dart';
import 'package:movies_database_app/presentation/bloc/search/search_cubit.dart';
import 'di/injection.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/details_page.dart';
import 'presentation/pages/bookmarks_page.dart';
import 'presentation/pages/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MoviesDatabaseApp());
}

class MoviesDatabaseApp extends StatelessWidget {
  const MoviesDatabaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'movie/:id',
              name: 'movieDetails',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return DetailsPage(movieId: id);
              },
            ),
            GoRoute(
              path: 'bookmarks',
              builder: (context, state) => const BookmarksPage(),
            ),
            GoRoute(
              path: 'search',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
      ],
    );

    final colorSeed = Colors.redAccent;
    final theme = ThemeData(
      colorSchemeSeed: colorSeed,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B0B0B),
      cardColor: const Color(0xFF141414),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>()..add(LoadHomeEvent()),
        ),
        BlocProvider<BookmarksBloc>(
          create: (_) => getIt<BookmarksBloc>()..add(LoadBookmarksEvent()),
        ),
        BlocProvider(create: (_) => getIt<SearchCubit>()),
        BlocProvider<DetailsBloc>(
          create: (_) => getIt<DetailsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MoviesDatabaseApp',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: router,
      ),
    );
  }
}
