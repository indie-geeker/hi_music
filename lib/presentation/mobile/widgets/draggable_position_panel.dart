import 'package:flutter/material.dart';

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

class DraggablePositionPanel extends StatefulWidget {
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
  State<DraggablePositionPanel> createState() => _DraggablePositionPanelState();
}

class _DraggablePositionPanelState extends State<DraggablePositionPanel> {
  double? dy;
  bool showAnimation = false;
  bool _isPanelVisible = true;

  @override
  void initState() {
    super.initState();
    // 如果提供了控制器，则注册状态
    if (widget.controller != null) {
      widget.controller!._registerState(this);
    }
  }

  // 显示面板
  void showPanel() {
    if (!_isPanelVisible) {
      setState(() {
        dy = widget.top;
        showAnimation = true;
        _isPanelVisible = true;
      });
    }
  }

  // 隐藏面板
  void hidePanel() {
    if (_isPanelVisible) {
      setState(() {
        final size = MediaQuery.of(context).size;
        dy = size.height - 4.0 - (8.0 * 2); // barHeight and barPadding
        showAnimation = true;
        _isPanelVisible = false;
      });
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
    const barHeight = 4.0;
    const barPadding = 8.0;
    return AnimatedPositioned(
        duration:
        showAnimation ? const Duration(milliseconds: 200) : Duration.zero,
        top: dy ?? widget.top,
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(4)),
          ),
          child: Column(
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
                    } else {
                      dy = size.height - barHeight - (barPadding * 2);
                      _isPanelVisible = false;
                    }
                    showAnimation = true;
                  });
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: barPadding),
                    child: Container(
                      width: 48,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xffc2c2c2),
                        borderRadius: BorderRadius.circular(barHeight),
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
