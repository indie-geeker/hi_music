import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hi_music/presentation/common/splash.dart';
import 'package:hi_music/presentation/mobile/home_screen.dart';

// 应用路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
