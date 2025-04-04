import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/common/banner_slider.dart';
import 'package:hi_music/presentation/mobile/collect_screen.dart';
import 'package:hi_music/presentation/mobile/widgets/double_back_to_close_app.dart';
import 'package:hi_music/presentation/mobile/widgets/home_bottom_appbar.dart';
import 'package:hi_music/presentation/viewmodels/home_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Widget> pages = [
    const Center(child: Text('音乐库', style: TextStyle(fontSize: 24))),
    const CollectScreen(),
    const Center(child: Text('个人中心', style: TextStyle(fontSize: 24))),
  ];
  int currentPage = 0;
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    // 确保页面初始化完成后加载数据
    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).loadData();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 72.0,
        height: 72.0,
        child: FloatingActionButton(
          elevation: currentPage == 1 ? 8.0 : 2.0,
          backgroundColor: currentPage == 1
              ? Colors.blue.withOpacity(0.7)
              : Colors.grey.withOpacity(0.7),
          shape: const CircleBorder(side: BorderSide.none),
          onPressed: () {
            setState(() {
              currentPage = 1;
              pageController.jumpToPage(1);
            });
          },
          child: Icon(
            Icons.music_note_outlined,
            color: currentPage == 1 ? Colors.white : Colors.white70,
            size: 60.0,
          ),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: HomeBottomAppBar(
        currentIndex: currentPage,
        onItemTapped: (int value) {
          setState(() {
            currentPage = value;
            pageController.jumpToPage(value);
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    return DoubleBackToCloseApp(
        child: PageView(
      // physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
      children: pages,
    ));
  }
}
