import 'dart:math';

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
  double? _dragStartDy; // 记录拖动开始时的手指位置
  double? _dragStartPanelTop; // 记录拖动开始时面板的顶部位置

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
    // 计算面板的高度，确保至少有足够空间放置拖动条
    // 增加5像素的额外空间，防止溢出
    // Column在计算布局时，可能因为内部渲染细节和像素对齐问题，造成轻微的舍入误差，需要额外几个像素来补偿
    double minHeight = _barHeight + (_barPadding * 2) + 5; 
    var panelHeight = max(minHeight, size.height - (dy ?? widget.top));

    return AnimatedPositioned(
        duration:
        showAnimation ? const Duration(milliseconds: 200) : Duration.zero,
        top: dy ?? widget.top,
        left: 0,
        right: 0,
        height: panelHeight, // 设置明确的高度
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragStart: (details) {
            // 记录拖动开始时的手指位置和面板位置
            _dragStartDy = details.globalPosition.dy;
            _dragStartPanelTop = dy ?? widget.top;
          },
          onVerticalDragUpdate: (detail) {
            if (_dragStartDy == null || _dragStartPanelTop == null) return;
            
            // 计算手指移动的距离
            final dragDelta = detail.globalPosition.dy - _dragStartDy!;
            // 计算新的面板位置，确保不会超出上边界
            final newTop = _dragStartPanelTop! + dragDelta;
            
            setState(() {
              showAnimation = false;
              dy = newTop <= widget.top ? widget.top : newTop;
            });
          },
          onVerticalDragEnd: (detail) {
            // 重置拖动开始记录
            _dragStartDy = null;
            _dragStartPanelTop = null;
            
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
          child: Container(
            height: panelHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //滚动区域指示器
                SizedBox(
                  height: _barHeight + _barPadding * 2,
                  width: double.infinity,
                  child: Center(
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
                Expanded(child: widget.child)
              ],
            ),
          ),
        ));
  }
}
