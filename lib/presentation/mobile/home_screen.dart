import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/common/banner_slider.dart';
import 'package:hi_music/presentation/mobile/collect_screen.dart';
import 'package:hi_music/presentation/mobile/music_screen.dart';
import 'package:hi_music/presentation/mobile/widgets/double_back_to_close_app.dart';
import 'package:hi_music/presentation/mobile/widgets/home_bottom_appbar.dart';
import 'package:hi_music/presentation/viewmodels/home_viewmodel.dart';
import 'package:hi_music/router/app_router.dart';

import '../viewmodels/play_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Widget> pages = [
    const MusicScreen(),
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
    Uint8List? rawImage = ref.watch(playViewmodelProvider.select((state) => state.image));

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
            if(currentPage == 1){
              // appRouter.push('/play');
              showModalBottomSheet(context: context, builder: (context) => Container(
                height: 600,
                color: Colors.blue,
              ));
              return;
            }
            setState(() {
              currentPage = 1;
              pageController.jumpToPage(1);
            });
          },
          child: rawImage != null ? ClipOval(
            child: Image.memory(
              rawImage,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ) : const Icon(
            Icons.music_note_outlined,
            color: Colors.white70,
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
      physics: const NeverScrollableScrollPhysics(),
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
