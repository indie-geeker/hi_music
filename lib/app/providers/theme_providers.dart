import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/theme_config.dart';

// 生成的代码将在此文件中
part 'theme_providers.g.dart';

/// 主题模式提供者
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    // 默认使用系统主题
    return ThemeMode.system;
  }
  
  /// 更新主题模式
  void updateThemeMode(ThemeMode mode) {
    state = mode;
  }
  
  /// 切换主题模式
  void toggleThemeMode() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}

/// 自定义主题颜色提供者
@riverpod
class ThemeColorsNotifier extends _$ThemeColorsNotifier {
  @override
  ({Color primary, Color secondary}) build() {
    // 默认颜色
    return (
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
    );
  }
  
  /// 更新主题颜色
  void updateColors({required Color primary, required Color secondary}) {
    state = (primary: primary, secondary: secondary);
  }
  
  /// 重置为默认颜色
  void resetToDefault() {
    state = (
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
    );
  }
}

/// 字体系列提供者
@riverpod
class FontFamilyNotifier extends _$FontFamilyNotifier {
  @override
  String build() {
    return 'PingFang SC'; // 默认字体
  }
  
  /// 更新字体
  void updateFontFamily(String fontFamily) {
    state = fontFamily;
  }
}

/// 主题配置提供者 - 组合以上所有提供者
@riverpod
ThemeConfig themeConfig(ThemeConfigRef ref) {
  final themeMode = ref.watch(themeModeNotifierProvider);
  final themeColors = ref.watch(themeColorsNotifierProvider);
  final fontFamily = ref.watch(fontFamilyNotifierProvider);
  
  // 如果使用自定义颜色
  if (themeColors.primary != AppColors.light.primary || 
      themeColors.secondary != AppColors.light.secondary) {
    return ThemeConfig.custom(
      themeMode: themeMode,
      fontFamily: fontFamily,
      primaryColor: themeColors.primary,
      secondaryColor: themeColors.secondary,
    );
  }
  
  // 使用默认主题配置，但应用当前的主题模式和字体
  final defaultConfig = ThemeConfig.defaultConfig();
  return defaultConfig.copyWith(
    themeMode: themeMode,
    fontFamily: fontFamily,
  );
}

/// 当前主题提供者 - 根据环境亮度选择适当的主题
@riverpod
AppTheme currentTheme(CurrentThemeRef ref, BuildContext context) {
  final config = ref.watch(themeConfigProvider);
  return config.getCurrentTheme(context);
}
