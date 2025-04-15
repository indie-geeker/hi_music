import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DoubleBackToCloseApp extends StatefulWidget {
  final Widget child;
  final String? message;
  final Duration? clickTimeout;
  final bool Function()? onBackPressed;

  const DoubleBackToCloseApp({super.key,
    required this.child,
    this.message,
    this.clickTimeout,
    this.onBackPressed,
  });

  @override
  State<DoubleBackToCloseApp> createState() => _DoubleBackToCloseAppState();
}

class _DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {

  DateTime? _lastPressedAt;
  String? _message;
  Duration? _clickTimeout ;


  @override
  void initState() {
    super.initState();
    _clickTimeout = widget.clickTimeout ?? const Duration(seconds: 2);
    _message = widget.message ?? "Press back again to exit";
  }

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;

    if (isAndroid) {
      return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            
            if (widget.onBackPressed != null) {
              bool continueWithExit = widget.onBackPressed!();
              if (!continueWithExit) {
                return;
              }
            }

            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt!) >
                    _clickTimeout!) {

              _lastPressedAt = DateTime.now();
              ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(_message!)));
              return ;
            }
            SystemNavigator.pop();
          },
          child: widget.child);
    }
    return widget.child;
  }
}
