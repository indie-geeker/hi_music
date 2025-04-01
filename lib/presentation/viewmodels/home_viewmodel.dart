import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi_music/presentation/common/banner_slider.dart';

/// HomeViewModel的状态
class HomeState {
  final List<BannerItem> bannerItems;
  final List<SongItem> songItems;
  final bool isLoading;
  final String? errorMessage;
  final SortOrder sortOrder;

  const HomeState({
    this.bannerItems = const [],
    this.songItems = const [],
    this.isLoading = false,
    this.errorMessage,
    this.sortOrder = SortOrder.newest,
  });

  // 创建一个新的状态实例
  HomeState copyWith({
    List<BannerItem>? bannerItems,
    List<SongItem>? songItems,
    bool? isLoading,
    String? errorMessage,
    SortOrder? sortOrder,
  }) {
    return HomeState(
      bannerItems: bannerItems ?? this.bannerItems,
      songItems: songItems ?? this.songItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// 排序方式枚举
enum SortOrder { newest, popular, alphabetical }

/// 歌曲项数据模型
class SongItem {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final int playCount;

  const SongItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    this.playCount = 0,
  });
}

/// HomeViewModel
/// 
/// 负责首页的业务逻辑和数据处理
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());

  /// 加载数据
  Future<void> loadData() async {
    // 设置加载状态
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 模拟Banner数据
      final bannerItems = [
        BannerItem(
          title: "Shadow",
          artist: "Syn Cole",
          album: "ALIDA",
          imageUrl: "assets/images/img1.jpg",
          color: const Color(0xFF0E7AC7),
        ),
        BannerItem(
          title: "Fireflies",
          artist: "Owl City",
          album: "Ocean Eyes",
          imageUrl: "assets/images/img2.jpg",
          color: const Color(0xFF5D11AB),
        ),
        BannerItem(
          title: "Starboy",
          artist: "The Weeknd",
          album: "Starboy",
          imageUrl: "assets/images/img2.jpg",
          color: const Color(0xFFEC441E),
        ),
      ];
      
      // 模拟歌曲列表数据
      final songItems = List.generate(
        30,
        (index) => SongItem(
          id: 'song_$index',
          title: "歌曲 ${index + 1}",
          artist: "歌手 ${index % 5 + 1}",
          duration: "${2 + index % 3}:${30 + index % 30}",
          playCount: 1000 - (index * 30),
        ),
      );
      
      // 更新状态
      state = state.copyWith(
        bannerItems: bannerItems,
        songItems: songItems,
        isLoading: false,
      );
    } catch (e) {
      // 处理错误
      state = state.copyWith(
        isLoading: false,
        errorMessage: "加载数据失败: $e",
      );
    }
  }
  
  /// 处理Banner选择事件
  void onBannerSelected(int index) {
    // 在实际应用中，这里可能会导航到详情页或播放音乐
    debugPrint('选择了Banner: ${state.bannerItems[index].title}');
  }
  
  /// 处理歌曲选择事件
  void onSongSelected(SongItem song) {
    // 在实际应用中，这里可能会播放选中的歌曲
    debugPrint('选择了歌曲: ${song.title}');
  }
  
  /// 切换排序方式
  void toggleSortOrder() {
    SortOrder newOrder;
    
    // 循环切换排序方式
    switch (state.sortOrder) {
      case SortOrder.newest:
        newOrder = SortOrder.popular;
        break;
      case SortOrder.popular:
        newOrder = SortOrder.alphabetical;
        break;
      case SortOrder.alphabetical:
        newOrder = SortOrder.newest;
        break;
    }
    
    // 根据排序方式对歌曲列表进行排序
    final sortedSongs = [...state.songItems];
    
    switch (newOrder) {
      case SortOrder.newest:
        // 保持原始顺序，假设原始顺序就是最新的
        break;
      case SortOrder.popular:
        // 按播放次数排序
        sortedSongs.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case SortOrder.alphabetical:
        // 按标题字母顺序排序
        sortedSongs.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    // 更新状态
    state = state.copyWith(
      songItems: sortedSongs,
      sortOrder: newOrder,
    );
  }
  
  /// 导航到设置页面
  void navigateToSettings() {
    // 在实际应用中，这里会使用路由导航到设置页面
    debugPrint('导航到设置页面');
  }
}

/// HomeViewModel的Provider
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel();
});
