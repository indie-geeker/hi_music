import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hi_music/presentation/viewmodels/splash_viewmodel.dart';

part 'splash_provider.g.dart';

// 使用Riverpod代码生成的方式定义Provider
@riverpod
SplashViewModel splashViewModel(SplashViewModelRef ref) {
  return SplashViewModel();
}

// 移除旧的Provider定义，避免名称冲突
// 现在我们只使用自动生成的Provider
