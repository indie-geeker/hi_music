import 'package:flutter/material.dart';

class BottomSheetPage extends Page {
  final Widget Function(ScrollController scrollController) builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const BottomSheetPage({
    required this.builder,
    this.initialChildSize = 1.0,
    this.minChildSize = 0.8,
    this.maxChildSize = 1.0,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route createRoute(BuildContext context) {
    return _BottomSheetRoute(
      builder: builder,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      settings: this, // 🌟 必须传入 settings 给 go_router 支持
    );
  }
}

class _BottomSheetRoute extends PageRoute<void> {
  final Widget Function(ScrollController scrollController) builder;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  _BottomSheetRoute({
    required this.builder,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    super.settings,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            if (notification.extent <= minChildSize + 0.05) {
              if(Navigator.canPop(context)){
                Navigator.of(context).maybePop();
              }
            }
            return false;
          },
          child: DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            expand: false,
            builder: (context, scrollController) {
              return Material(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                clipBehavior: Clip.antiAlias,
                elevation: 12,
                color: Theme.of(context).canvasColor,
                child: builder(scrollController),
              );
            },
          ),
        ),
      ),
    );
  }
}