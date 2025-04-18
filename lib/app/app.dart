import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Riverpod 获取主题配置
    final themeConfig = ref.watch(themeConfigProvider);
    
    return MaterialApp(
      title: '音乐应用',
      // 使用主题配置
      theme: themeConfig.lightTheme.themeData,
      darkTheme: themeConfig.darkTheme.themeData,
      themeMode: themeConfig.themeMode,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Riverpod 获取当前主题
    final currentTheme = ref.watch(currentThemeProvider(context));
    final colors = currentTheme.colors;
    final textStyles = currentTheme.textStyles;
    
    // 获取主题模式控制器
    final themeModeNotifier = ref.watch(themeModeNotifierProvider.notifier);
    
    // 获取主题颜色控制器
    final themeColorsNotifier = ref.watch(themeColorsNotifierProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐应用'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用主题颜色和文字样式
            Text(
              '当前主题模式: ${_getThemeModeName(ref.watch(themeModeNotifierProvider))}',
              style: textStyles.bodyText1,
            ),
            const SizedBox(height: 20),
            
            // 主题切换按钮
            ElevatedButton(
              onPressed: () {
                // 切换主题模式
                themeModeNotifier.toggleThemeMode();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: colors.primary,
              ),
              child: Text('切换主题', style: textStyles.button),
            ),
            
            const SizedBox(height: 10),
            
            // 自定义主题颜色按钮
            ElevatedButton(
              onPressed: () {
                // 自定义主题颜色
                themeColorsNotifier.updateColors(
                  primary: Colors.purple,
                  secondary: Colors.amber,
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: colors.secondary,
              ),
              child: Text('自定义颜色', style: textStyles.button),
            ),
            
            const SizedBox(height: 10),
            
            // 重置主题颜色按钮
            ElevatedButton(
              onPressed: () {
                // 重置为默认颜色
                themeColorsNotifier.resetToDefault();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: colors.error,
              ),
              child: Text('重置颜色', style: textStyles.button),
            ),
          ],
        ),
      ),
    );
  }
  
  // 获取主题模式名称
  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
      case ThemeMode.system:
        return '跟随系统';
    }
  }
}