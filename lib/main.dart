import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 使用 ProviderScope 包装应用
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
