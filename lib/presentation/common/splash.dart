import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/providers/splash_provider.dart';

/// Splash页面 - 应用启动时的首屏
/// 
/// 使用MVVM模式：
/// - View: 当前的SplashScreen类，负责UI展示
/// - ViewModel: 通过Riverpod注入的SplashViewModel，负责业务逻辑
/// - Model: 在这个简单的场景中没有明确的数据模型
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 在初始化时启动计时器，2秒后自动跳转
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取ViewModel并调用导航方法
      // 使用自动生成的Provider
      final viewModel = ref.read(splashViewModelProvider);
      viewModel.navigateToNextScreen(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // 使用渐变背景
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 应用Logo
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(75),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Color(0xFF6A11CB),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // 应用名称
              const Text(
                'Hi Music',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // 加载指示器
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}