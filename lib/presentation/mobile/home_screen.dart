import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/common/banner_slider.dart';
import 'package:hi_music/presentation/mobile/collect_screen.dart';
import 'package:hi_music/presentation/mobile/music_screen.dart';
import 'package:hi_music/presentation/mobile/widgets/double_back_to_close_app.dart';
import 'package:hi_music/presentation/mobile/widgets/draggable_position_panel.dart';
import 'package:hi_music/presentation/mobile/widgets/home_bottom_appbar.dart';
import 'package:hi_music/presentation/viewmodels/home_viewmodel.dart';
import 'package:hi_music/providers/panel_provider.dart';
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

  final _panelController = DraggablePanelController();

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
    Uint8List? rawImage =
        ref.watch(playViewmodelProvider.select((state) => state.image));

    // 监听面板状态变化
    ref.listen(panelStateProvider, (previous, next) {
      if (next) {
        _panelController.open();
      } else {
        _panelController.close();
      }
    });

    return Stack(
      children: [
        Scaffold(
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
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
                if (currentPage == 1) {
                  // 通过Provider控制面板状态
                  ref.read(panelStateProvider.notifier).toggle();
                  return;
                }
                setState(() {
                  currentPage = 1;
                  pageController.jumpToPage(1);
                });
              },
              child: rawImage != null
                  ? ClipOval(
                      child: Image.memory(
                        rawImage,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
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
        ),
        DraggablePositionPanel(
            controller: _panelController,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.green,
              ),
            ))
      ],
    );
  }

  Widget _buildBody() {
    return DoubleBackToCloseApp(
        message: '再次点击退出',
        onBackPressed: () {
          // 如果面板处于显示状态，先关闭面板
          if (ref.read(panelStateProvider)) {
            ref.read(panelStateProvider.notifier).close();
            return false; // 返回false表示已处理返回事件，不继续执行双击退出逻辑
          }
          return true; // 返回true表示继续执行双击退出逻辑
        },
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
