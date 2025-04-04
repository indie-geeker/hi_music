import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scroll);

    Future.microtask((){
      ref.read(homeViewModelProvider.notifier).loadData();
    });
  }

  void _scroll(){
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
                      stops: const [0.6,1.0]
                  ),
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
                      ]
                  ),
                ),
              ),
            )
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
              expandedHeight: 205,  // 展开时的高度
              collapsedHeight: 60,  // 收起时的高度
              pinned: false,
              floating: true,       // 向下滑动时立即显示
              snap: true,           // 与floating配合，决定是否在滑动时直接展开到完整高度
              flexibleSpace: FlexibleSpaceBar(
                background: BannerSlider(
                  height: 180,
                  items: state.bannerItems,
                  viewportFraction: 0.8,
                  stackOffset: 30,
                  onPageChanged: (index){
                    debugPrint("banner change to $index");
                    setState(() {
                      bannerColor =  state.bannerItems[index].color;
                    });
                  },
                ),  // 展开时显示的内容
                // title: Text("title"),
                // centerTitle: false,
                // titlePadding: EdgeInsets.only(left: 16, bottom: 16),
              ),
            ),
            SliverPersistentHeader(
              pinned: true, // 设置为true时，滚动时会固定在顶部
              delegate: _MySliverPersistentHeaderDelegate(
                title: "热门推荐",
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _buildSongItem(context,state.songItems[index]);
                  },
                  childCount: state.songItems.length
              ),
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
          trailing: Text(songItem.duration),
          onTap: () => ref.read(homeViewModelProvider.notifier).onSongSelected(songItem),
        ),
        Divider(height: 1,color: Colors.grey[100],),
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
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
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