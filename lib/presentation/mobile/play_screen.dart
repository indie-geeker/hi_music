import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayScreen extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const PlayScreen({super.key,
    required this.scrollController,
  });

  @override
  ConsumerState createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: [
          Container(
            height: 300,
            color: Colors.red,
          ),
          Container(
            height: 300,
            color: Colors.green,
          ),
          Container(
            height: 300,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
