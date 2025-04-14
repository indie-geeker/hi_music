import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/mobile/widgets/draggable_position_panel.dart';

import '../common/banner_slider.dart';
import '../viewmodels/home_viewmodel.dart';
import 'widgets/home_bottom_appbar.dart';

class CollectScreen extends ConsumerStatefulWidget {
  const CollectScreen({super.key});

  @override
  ConsumerState createState() => _CollectScreenState();
}

class _CollectScreenState extends ConsumerState<CollectScreen> {
  //   // AppBar背景透明度
  double appBarOpacity = 1.0;
  double appBarHeight = kToolbarHeight;
  final scrollController = ScrollController();
  Color appBarTitleColor = Colors.white;
  Color bannerColor = Colors.blue;

  // 添加控制器
  final _panelController = DraggablePanelController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scroll);

    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).loadData();
    });
  }

  void _scroll() {
    double scrollOffset = scrollController.offset;
    double opactity = (scrollOffset / appBarHeight).clamp(0.0, 1.0);
    // if(opactity != appBarOpacity){
    //   setState(() {
    //     appBarOpacity = opactity;
    //     appBarTitleColor = Colors.white.withOpacity(opactity);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);

    return Stack(
      children: [
        Container(
          color: Colors.blue,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 800,
                    color: Colors.red,
                  ),
                  Container(
                    height: 800,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
        DraggablePositionPanel(
          top: 200,
          controller: _panelController, // 传递控制器
          child: Container(
            color: Colors.green,
          ),
        ),
        // 添加一个按钮来重新弹出面板（可选）
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              _panelController.open(); // 调用控制器的 open 方法
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            // appbar 渐变背景
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        bannerColor.withOpacity(appBarOpacity * 0.8),
                        bannerColor.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.6, 1.0]),
                ),
              ),
            ),

            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: appBarOpacity.clamp(0, 1),
                child: Text(
                  "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appBarTitleColor,
                      shadows: [
                        Shadow(
                          color: appBarTitleColor.withOpacity(0.5),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            // SliverToBoxAdapter(
            //   child: BannerWidget(),
            // ),
            SliverAppBar(
              expandedHeight: 205,
              // 展开时的高度
              collapsedHeight: 60,
              // 收起时的高度
              pinned: false,
              floating: true,
              // 向下滑动时立即显示
              snap: true,
              // 与floating配合，决定是否在滑动时直接展开到完整高度
              flexibleSpace: FlexibleSpaceBar(
                background: BannerSlider(
                  height: 180,
                  items: state.bannerItems,
                  viewportFraction: 0.8,
                  stackOffset: 30,
                  onPageChanged: (index) {
                    debugPrint("banner change to $index");
                    setState(() {
                      ref.read(homeViewModelProvider.notifier).onBannerSelected(index);
                      bannerColor = state.bannerItems[index].color;
                    });
                  },
                ), // 展开时显示的内容
                // title: Text("title"),
                // centerTitle: false,
                // titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
            SliverPersistentHeader(
              pinned: true, // 设置为true时，滚动时会固定在顶部
              delegate: _MySliverPersistentHeaderDelegate(
                title: "最近播放",
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildSongItem(context, state.songItems[index]);
              },
                  childCount: state.songItems.length),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(BuildContext context, SongItem songItem) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.music_note, color: Colors.green),
          ),
          title: Text(songItem.title),
          subtitle: Text(songItem.artist),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(songItem.duration),
              const SizedBox(height: 10),
              Icon(
                Icons.more_vert,
                color: Colors.grey[400],
              ),
            ],
          ),
          onTap: () =>
              ref.read(homeViewModelProvider.notifier).onSongSelected(songItem),
        ),
        Divider(
          height: 1,
          color: Colors.grey[100],
        ),
      ],
    );
  }
}

// 自定义的SliverPersistentHeaderDelegate实现
class _MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  _MySliverPersistentHeaderDelegate({
    required this.title,
    this.height = 90.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            label: const Text(
              "播放全部",
              style: TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 8,right: 8),
              backgroundColor: Colors.green.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(
              Icons.play_circle,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_MySliverPersistentHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || height != oldDelegate.height;
  }
}
