import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Splash页面的ViewModel
/// 
/// 负责Splash页面的业务逻辑，包括：
/// - 延迟加载
/// - 页面跳转
class SplashViewModel {
  /// 控制页面跳转的方法
  /// 
  /// 延迟2秒后使用go_router跳转到主页面
  Future<void> navigateToNextScreen(BuildContext context) async {
    // 延迟2秒后跳转
    await Future.delayed(const Duration(seconds: 2));
    
    // 使用GoRouter跳转到主页面
    // 这里使用go方法确保splash页面被替换
    if (context.mounted) {
      context.go('/home');
    }
  }
}
