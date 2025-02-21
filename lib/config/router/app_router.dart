import 'package:flutter_app_sportly/presentation/screens/home_screens.dart';
import 'package:flutter_app_sportly/presentation/screens/initial_screen.dart';
import 'package:flutter_app_sportly/presentation/views/football_matches.dart';
import 'package:flutter_app_sportly/presentation/views/table_posiciones_soccer.dart';
import 'package:flutter_app_sportly/presentation/views/statistics_views.dart';
// import 'package:flutter_app_sportly/presentation/views/statistics_views.dart';
// import 'package:flutter_app_sportly/presentation/views/scores_views.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/initial', routes: [
  GoRoute(
      path: '/initial',
      name: InitialScreen.name,
      builder: (context, state) {
        return const InitialScreen();
      },
      routes: [
        GoRoute(
            path: 'home/:code/:page',
            name: HomeScreen.name,
            builder: (context, state) {
              final pageIndex = int.parse(state.params['page'] ?? '0');
              final code = state.params['code'] ?? '';
              return HomeScreen(
                pageIndex: pageIndex,
                code: code,
              );
            }),
        GoRoute(
          path: 'scores/:code',
          name: ScoresViews.name,
          builder: (context, state) {
            //final pageIndex = int.parse(state.params['page'] ?? '0');
            final code = state.params['code'] ?? '';
            return ScoresViews(code: code);
          },
        ),
        GoRoute(
            path: 'statistics/:code',
            name: StatisticsViews.name,
            builder: (context, state) {
              final code = state.params['code'] ?? '';
              return StatisticsViews(code: code);
            }),
        GoRoute(
            name: FootballMatches.name,
            path: 'football_matches/:code/:page',
            builder: (context, state) {
              final code = state.params['code'] ?? '';
              final pageIndex = int.parse(state.params['page'] ?? '');
              return FootballMatches(code: code , pageIndex: pageIndex);
            })
      ]),
  //
  GoRoute(
    path: '/',
    redirect: (_, __) => '/home/0',
  ),
]);
