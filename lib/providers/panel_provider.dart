import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'panel_provider.g.dart';

/// 面板状态提供者，用于控制可拖动面板的开关状态
@riverpod
class PanelState extends _$PanelState {
  @override
  bool build() {
    // 默认面板状态为关闭
    return false;
  }

  /// 切换面板状态
  void toggle() {
    state = !state;
  }

  /// 打开面板
  void open() {
    state = true;
  }

  /// 关闭面板
  void close() {
    state = false;
  }
}
