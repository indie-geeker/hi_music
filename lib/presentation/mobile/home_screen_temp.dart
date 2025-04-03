// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hi_music/presentation/common/banner_slider.dart';
// import 'package:hi_music/presentation/viewmodels/home_viewmodel.dart';
//
// /// 首页屏幕
// ///
// /// 实现了带视差滚动效果的音乐应用首页，包含Banner轮播和歌曲列表
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   // 滚动控制器
//   final ScrollController _scrollController = ScrollController();
//
//   // 控制Banner的高度
//   double _bannerHeight = kInitialBannerHeight;
//
//   // 是否显示吸顶标题
//   bool _showPinnedTitle = false;
//
//   // 当前选中的Banner索引
//   int _currentBannerIndex = 0;
//
//   // AppBar背景透明度
//   double _appBarOpacity = 0.0;
//
//   // 常量定义
//   static const double kInitialBannerHeight = 260.0;
//   static const double kMinBannerHeight = 0.0;
//   static const double kScrollThreshold = 250.0;
//   static const double kIndicatorHeight = 30.0;
//   static const double kHeaderHeight = 60.0;
//   static const double kAppBarOpacityScrollRange = 120.0; // 控制AppBar透明度变化的滚动范围
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 监听滚动事件
//     _scrollController.addListener(_onScroll);
//
//     // 初始化ViewModel
//     Future.microtask(() {
//       ref.read(homeViewModelProvider.notifier).loadData();
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   // 处理滚动事件
//   void _onScroll() {
//     // 计算Banner的高度
//     final double scrollOffset = _scrollController.offset;
//     double newHeight = kInitialBannerHeight - scrollOffset;
//
//     // 限制最小高度
//     newHeight = newHeight.clamp(kMinBannerHeight, kInitialBannerHeight);
//
//     // 判断是否显示吸顶标题
//     bool showTitle = scrollOffset > kScrollThreshold;
//
//     // 计算AppBar背景透明度
//     double opacity = (scrollOffset / kAppBarOpacityScrollRange).clamp(0.0, 1.0);
//
//     // 更新状态
//     if (newHeight != _bannerHeight ||
//         showTitle != _showPinnedTitle ||
//         opacity != _appBarOpacity) {
//       setState(() {
//         _bannerHeight = newHeight;
//         _showPinnedTitle = showTitle;
//         _appBarOpacity = opacity;
//       });
//     }
//   }
//
//   // 处理Banner点击事件
//   void _onBannerTap(int index) {
//     setState(() {
//       _currentBannerIndex = index;
//     });
//
//     // 调用ViewModel处理业务逻辑
//     ref.read(homeViewModelProvider.notifier).onBannerSelected(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 计算状态栏高度
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//
//     // 监听ViewModel状态
//     final state = ref.watch(homeViewModelProvider);
//
//     // 如果数据正在加载，显示加载指示器
//     if (state.isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     // 获取数据
//     final bannerItems = state.bannerItems;
//     final listItems = state.songItems;
//
//     // 计算指示器高度
//     final double indicatorHeight = bannerItems.length > 1 ? kIndicatorHeight : 0.0;
//
//     // 计算Banner是否可见
//     final bool isBannerVisible = _bannerHeight > 0;
//
//     // 获取当前选中Banner的颜色
//     Color bannerColor = Colors.blue;
//     if (bannerItems.isNotEmpty && _currentBannerIndex < bannerItems.length) {
//       bannerColor = bannerItems[_currentBannerIndex].color;
//     }
//
//     // 计算AppBar文字和图标颜色
//     final Color appBarContentColor = _appBarOpacity > 0.5 ? Colors.white : Colors.black87;
//
//     return Scaffold(
//       extendBodyBehindAppBar: false, // 不允许内容延伸到AppBar后面
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: Stack(
//           children: [
//             // AppBar背景渐变
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       bannerColor.withOpacity(_appBarOpacity * 0.8),
//                       bannerColor.withOpacity(0),
//                     ],
//                     stops: const [0.7, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             // AppBar内容
//             AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               title: AnimatedOpacity(
//                 opacity: (_appBarOpacity * 2.0).clamp(0.0, 1.0),
//                 duration: const Duration(milliseconds: 150),
//                 child: Text(
//                   bannerItems.isNotEmpty && _currentBannerIndex < bannerItems.length
//                       ? bannerItems[_currentBannerIndex].title
//                       : "",
//                   style: TextStyle(
//                     color: appBarContentColor,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         offset: const Offset(1, 1),
//                         blurRadius: 2.0,
//                         color: Colors.black.withOpacity(0.5),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.settings),
//                   color: appBarContentColor,
//                   onPressed: () => ref.read(homeViewModelProvider.notifier).navigateToSettings(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           // 主内容区域
//           CustomScrollView(
//             controller: _scrollController,
//             slivers: [
//               // 顶部空间，用于放置Banner
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: kInitialBannerHeight + indicatorHeight, // 移除statusBarHeight和kToolbarHeight
//                 ),
//               ),
//
//               // 列表标题
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _SliverHeaderDelegate(
//                   minHeight: kHeaderHeight,
//                   maxHeight: kHeaderHeight,
//                   child: _buildSectionHeader(context),
//                 ),
//               ),
//
//               // 列表内容
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) => _buildListItem(context, listItems[index]),
//                   childCount: listItems.length,
//                 ),
//               ),
//
//               // 底部填充
//               const SliverToBoxAdapter(
//                 child: SizedBox(height: 20),
//               ),
//             ],
//           ),
//
//           // Banner区域，随滚动缩小
//           if (isBannerVisible) // 只有当Banner可见时才渲染
//             Positioned(
//               top: 0, // 从body顶部开始，不再加上statusBarHeight和kToolbarHeight
//               left: 0,
//               right: 0,
//               child: AnimatedOpacity(
//                 opacity: (_bannerHeight / kInitialBannerHeight).clamp(0.0, 1.0),
//                 duration: const Duration(milliseconds: 150),
//                 child: SizedBox(
//                   height: _bannerHeight + indicatorHeight,
//                   child: BannerSlider(
//                     items: bannerItems,
//                     height: _bannerHeight,
//                     viewportFraction: 0.7,
//                     stackOffset: 0,
//                     onItemTap: _onBannerTap,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   // 构建章节标题
//   Widget _buildSectionHeader(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             offset: const Offset(0, -1),
//             blurRadius: 2,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Row(
//         children: [
//           const Text(
//             "热门歌曲",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Spacer(),
//           IconButton(
//             icon: const Icon(Icons.sort),
//             onPressed: () => ref.read(homeViewModelProvider.notifier).toggleSortOrder(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 构建列表项
//   Widget _buildListItem(BuildContext context, SongItem item) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.grey.shade200,
//         child: const Icon(Icons.music_note, color: Colors.grey),
//       ),
//       title: Text(item.title),
//       subtitle: Text(item.artist),
//       trailing: Text(item.duration),
//       onTap: () => ref.read(homeViewModelProvider.notifier).onSongSelected(item),
//     );
//   }
// }
//
// // 用于创建吸顶效果的代理类
// class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final double minHeight;
//   final double maxHeight;
//   final Widget child;
//
//   _SliverHeaderDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });
//
//   @override
//   double get minExtent => minHeight;
//
//   @override
//   double get maxExtent => maxHeight;
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }
//
//   @override
//   bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
