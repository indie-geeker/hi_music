import 'package:flutter/material.dart';

class HomeBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const HomeBottomAppBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              onItemTapped(0);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                   Icon(
                  Icons.library_music,
                  color: currentIndex == 0 ? Colors.blue : Colors.black26,
                ),
                Text(
                  '音乐库',
                  style: TextStyle(
                    fontSize: 10,
                    color: currentIndex == 0 ? Colors.blue : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(), // 中间的空白区域
          GestureDetector(
            onTap: () {
              onItemTapped(2);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: currentIndex == 2 ? Colors.blue : Colors.black26,
                ),
                Text(
                  '设置',
                  style: TextStyle(
                    fontSize: 10,
                    color: currentIndex == 2 ? Colors.blue : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
