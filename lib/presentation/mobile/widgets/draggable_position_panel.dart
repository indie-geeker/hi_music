import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/providers/panel_provider.dart';

// 添加一个控制器类来控制面板
class DraggablePanelController {
  _DraggablePositionPanelState? _panelState;

  // 注册状态
  void _registerState(_DraggablePositionPanelState state) {
    _panelState = state;
  }

  // 打开面板
  void open() {
    _panelState?.showPanel();
  }

  // 关闭面板
  void close() {
    _panelState?.hidePanel();
  }

  // 切换面板状态
  void toggle() {
    _panelState?.togglePanel();
  }
}

class DraggablePositionPanel extends ConsumerStatefulWidget {
  const DraggablePositionPanel({
    super.key,
    required this.child,
    this.top = 0,
    this.controller,
  });

  final double top;
  final Widget child;
  final DraggablePanelController? controller;

  @override
  ConsumerState<DraggablePositionPanel> createState() => _DraggablePositionPanelState();
}

const _barHeight = 8.0;
const _barPadding = 8.0;

class _DraggablePositionPanelState extends ConsumerState<DraggablePositionPanel> {
  double? dy;
  bool showAnimation = false;
  bool _isPanelVisible = false; // 默认为收起状态

  @override
  void initState() {
    super.initState();
    // 如果提供了控制器，则注册状态
    if (widget.controller != null) {
      widget.controller!._registerState(this);
    }
    
    // 初始化时设置面板位置为收起状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPanelVisible) {
        final size = MediaQuery.of(context).size;
        setState(() {
          // dy = size.height - _barHeight - (_barPadding * 2); // 保留拖动区域
          dy = size.height;
        });
      }
    });
  }

  // 显示面板
  void showPanel() {
    if (!_isPanelVisible) {
      setState(() {
        dy = widget.top;
        showAnimation = true;
        _isPanelVisible = true;
      });
      // 同步更新Provider状态，但先检查当前Provider状态，避免循环
      if (ref.read(panelStateProvider) == false) {
        ref.read(panelStateProvider.notifier).open();
      }
    }
  }

  // 隐藏面板
  void hidePanel() {
    if (_isPanelVisible) {
      setState(() {
        final size = MediaQuery.of(context).size;
        // dy = size.height - _barHeight - (_barPadding * 2); // 保留拖动区域
        dy = size.height;
        showAnimation = true;
        _isPanelVisible = false;
      });
      // 同步更新Provider状态，但先检查当前Provider状态，避免循环
      if (ref.read(panelStateProvider) == true) {
        ref.read(panelStateProvider.notifier).close();
      }
    }
  }

  // 切换面板状态
  void togglePanel() {
    if (_isPanelVisible) {
      hidePanel();
    } else {
      showPanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // 计算面板的高度
    final panelHeight = size.height - (dy ?? widget.top);

    return AnimatedPositioned(
        duration:
        showAnimation ? const Duration(milliseconds: 200) : Duration.zero,
        top: dy ?? widget.top,
        left: 0,
        right: 0,
        height: panelHeight, // 设置明确的高度
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //滚动区域
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (detail) {
                  setState(() {
                    showAnimation = false;
                    dy = detail.globalPosition.dy <= widget.top
                        ? widget.top
                        : detail.globalPosition.dy;
                  });
                },
                onVerticalDragEnd: (detail) {
                  final size = MediaQuery.of(context).size;
                  final threshold = (size.height - widget.top) / 2;
                  setState(() {
                    if (dy != null && dy! <= threshold) {
                      dy = widget.top;
                      _isPanelVisible = true;
                      // 同步更新Provider状态，但先检查当前Provider状态，避免循环
                      if (ref.read(panelStateProvider) == false) {
                        ref.read(panelStateProvider.notifier).open();
                      }
                    } else {
                     // dy = size.height - _barHeight - (_barPadding * 2); // 保留拖动区域
                      dy = size.height;
                      _isPanelVisible = false;
                      // 同步更新Provider状态，但先检查当前Provider状态，避免循环
                      if (ref.read(panelStateProvider) == true) {
                        ref.read(panelStateProvider.notifier).close();
                      }
                    }
                    showAnimation = true;
                  });
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: _barPadding),
                    child: Container(
                      width: 48,
                      height: _barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xffc2c2c2),
                        borderRadius: BorderRadius.circular(_barHeight),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: widget.child)
            ],
          ),
        ));
  }
}
