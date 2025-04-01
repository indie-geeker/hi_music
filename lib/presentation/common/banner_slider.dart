import 'package:flutter/material.dart';

/// 轮播Banner组件
/// 
/// 实现类似Android ViewPager的重叠效果，两边的item可见并被中间item部分覆盖
class BannerSlider extends StatefulWidget {
  /// Banner项列表
  final List<BannerItem> items;
  
  /// Banner高度
  final double height;
  
  /// 点击Banner项的回调
  final Function(int index)? onItemTap;
  
  /// 视窗比例，控制两边项目的可见程度
  final double viewportFraction;
  
  /// 当前项目的缩放比例
  final double activeScale;
  
  /// 非当前项目的缩放比例
  final double inactiveScale;
  
  /// 层叠效果的偏移量，控制item之间的重叠程度
  final double stackOffset;
  
  const BannerSlider({
    super.key,
    required this.items,
    this.height = 260,
    this.onItemTap,
    this.viewportFraction = 0.85,
    this.activeScale = 1.0,
    this.inactiveScale = 0.9,
    this.stackOffset = 30.0,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  // 当前页面索引
  int _currentPage = 0;
  
  // 页面控制器
  late final PageController _pageController;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化页面控制器
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: widget.viewportFraction,
    );
    
    // 监听页面滚动
    _pageController.addListener(() {
      setState(() {
        int next = _pageController.page!.round();
        if (_currentPage != next) {
          _currentPage = next;
        }
      });
    });
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height + 30, // 增加高度以容纳指示器
      child: Column(
        mainAxisSize: MainAxisSize.min, // 使Column尽可能小
        children: [
          // Banner区域
          Expanded(
            child: ClipRect(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  // 计算当前项与目标项的距离
                  double distance = 0;
                  try {
                    distance = (index.toDouble() - (_pageController.page ?? 0)).abs().toDouble();
                  } catch (e) {
                    // 将int转换为double
                    distance = (index.toDouble() - _currentPage.toDouble()).abs();
                  }
                  
                  // 根据距离计算缩放比例
                  double scale = 1.0 - (distance * 0.1);
                  scale = scale.clamp(widget.inactiveScale, widget.activeScale);
                  
                  // 计算水平偏移量，创建层叠效果
                  double horizontalOffset = 0;
                  if (_pageController.position.haveDimensions) {
                    try {
                      double page = _pageController.page ?? 0;
                      if (index > page) {
                        // 右侧项目，向右偏移
                        horizontalOffset = -widget.stackOffset * (index.toDouble() - page).toDouble();
                      } else if (index < page) {
                        // 左侧项目，向左偏移
                        horizontalOffset = widget.stackOffset * (page - index.toDouble()).toDouble();
                      }
                    } catch (e) {
                      // 忽略可能的错误
                    }
                  }
                  
                  return Transform.translate(
                    offset: Offset(horizontalOffset, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onItemTap != null) {
                            widget.onItemTap!(index);
                          }
                        },
                        child: _buildBannerItem(widget.items[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 页面指示器
          if (widget.items.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.items.length, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index 
                          ? widget.items[_currentPage].color
                          : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
  
  // 构建Banner项
  Widget _buildBannerItem(BannerItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            // 背景图片
            Positioned.fill(
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 图片加载失败时显示颜色块
                  return Container(
                    color: item.color,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.white, size: 50),
                    ),
                  );
                },
              ),
            ),
            // 渐变遮罩
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            // 文本信息
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.artist} · ${item.album}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner项数据模型
class BannerItem {
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final Color color;

  const BannerItem({
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.color,
  });
}
