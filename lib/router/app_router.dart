import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hi_music/presentation/common/splash.dart';
import 'package:hi_music/presentation/mobile/home_screen.dart';
import 'package:hi_music/presentation/mobile/widgets/bottom_sheet_page.dart';

import '../presentation/mobile/play_screen.dart';

// 应用路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
          );
        },
        routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'play',
        path: '/play',
        pageBuilder: (context, state) => BottomSheetPage(
          builder: (ScrollController scrollController) => PlayScreen(
            scrollController: scrollController,
          ),
        ),
      ),
    ]),

  ],
);
