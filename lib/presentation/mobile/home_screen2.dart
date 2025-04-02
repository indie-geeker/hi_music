import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/common/banner_widget.dart';
import 'package:hi_music/presentation/viewmodels/home_viewmodel.dart';

class HomeScreen2 extends ConsumerStatefulWidget {
  const HomeScreen2({super.key});

  @override
  ConsumerState createState() => _HomeScreen2State();
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

class _HomeScreen2State extends ConsumerState<HomeScreen2> {
  @override
  void initState() {
    super.initState();

    Future.microtask((){
      ref.read(homeViewModelProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);


    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverToBoxAdapter(
            //   child: BannerWidget(),
            // ),
            SliverAppBar(
              expandedHeight: 180,  // 展开时的高度
              collapsedHeight: 60,  // 收起时的高度
              pinned: false,
              floating: true,       // 向下滑动时立即显示
              snap: true,           // 与floating配合，决定是否在滑动时直接展开到完整高度
              flexibleSpace: FlexibleSpaceBar(
                background: BannerWidget(
                  height: 180,
                  items: state.bannerItems,
                  viewportFraction: 0.7,
                  stackOffset: 30,
                ),  // 展开时显示的内容
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 16, bottom: 16),
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
                  return Column(
                    children: [
                      Text("item $index"),
                      if (index < 29) const Divider(),
                    ],
                  );
                },
                childCount: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
