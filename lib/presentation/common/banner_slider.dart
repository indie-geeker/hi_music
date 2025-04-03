import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  /// Banner项列表
  final List<BannerItem> items;

  /// Banner高度
  final double height;

  /// 视窗比例，控制两边项目的可见程度
  final double viewportFraction;

  /// 当前Item的缩放比例
  final double activeScale;

  /// 非当前Item的缩放比例
  final double inactiveScale;

  /// 层叠效果的偏移量，控制item之间的重叠程度
  final double stackOffset;

  /// 点击Banner项的回调
  final Function(int index)? onItemTap;

  /// Banner变化时的回调
  final Function(int index)? onPageChanged;

  const BannerSlider(
      {super.key,
      required this.items,
      this.height = 180,
      this.viewportFraction = 0.85,
      this.activeScale = 1,
      this.inactiveScale = 0.85,
      this.stackOffset = 20,
      this.onItemTap,
      this.onPageChanged
      });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late final PageController _pageController;

  // 当前页面索引
  int _currentPage = 0;

  // 页面指示器高度
  double indicatorHeight = 30;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
        initialPage: 0, viewportFraction: widget.viewportFraction);
    _pageController.addListener(() {
      setState(() {
        int index = _pageController.page?.round() ?? 0;
        if (index != _currentPage) {
          _currentPage = index;
          widget.onPageChanged?.call(index);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height + indicatorHeight,
      color: Colors.white.withOpacity(0.6),
      child: Stack(
        children: [
          SizedBox(
            height: widget.height,
            child: ClipRect(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  padEnds: true,
                  pageSnapping: true,
                  itemBuilder: (context, index) {
                    // 计算当前项与目标项的距离
                    double distance = 0;
                    try {
                      distance =
                          (index - (_pageController.page ?? 0)).abs().toDouble();
                    } catch (e) {
                      debugPrint(e.toString());
                      distance = (index - _currentPage).abs().toDouble();
                    }
                    // 根据距离计算缩放比，每个单位缩小 0.1
                    double scale = 1.0 - (distance * 0.1);
                    scale = scale.clamp(widget.inactiveScale, widget.activeScale);

                    // 计算水平偏移量，创建层叠效果
                    double horizontalOffset = 0;
                    // 确保页面控制器已经初始化
                    if (_pageController.position.haveDimensions) {
                      try {
                        double page =
                            _pageController.page ?? _currentPage.toDouble();
                        // 右侧Item，向右偏移
                        if (index > page) {
                          horizontalOffset = -widget.stackOffset * (index - page);
                        }
                        // 左侧Item，向左偏移
                        else if (index < page) {
                          horizontalOffset = widget.stackOffset * (page - index);
                        }
                      } catch (e) {
                        // 忽略可能的异常
                        debugPrint(e.toString());
                      }
                    }

                    return Transform.translate(
                      offset: Offset(horizontalOffset, 0),
                      child: Transform.scale(
                        scale: scale,
                        child: InkWell(
                          onTap: () {
                            widget.onItemTap?.call(index);
                          },
                          child: _buildBannerItem(widget.items[index]),
                        ),
                      ),
                    );
                  }),
            ),
          ),

          // 页面指示器
          // if (widget.items.length > 1)
          //   Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: Center(
          //       child: IntrinsicWidth(
          //         child: Container(
          //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //           decoration: BoxDecoration(
          //             color: Colors.black.withOpacity(0.3),
          //             borderRadius: const BorderRadius.all(Radius.circular(10)),
          //           ),
          //           child: Text(
          //             "${_currentPage + 1}/${widget.items.length}",
          //             style: const TextStyle(fontSize: 10, color: Colors.white),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }

  Widget _buildBannerItem(BannerItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: item.color, blurRadius: 15, offset: const Offset(0, 8))
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 背景图片
            Positioned.fill(
                child: Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: item.color,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                );
              },
            )),

            // 渐变遮罩层
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7)
                  ],
                      stops: const [
                    0.6,
                    1.0
                  ])),
            )),

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
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      item.artist,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class BannerItem {
  final String title;
  final String artist;
  final String imageUrl;
  final Color color;

  BannerItem(
      {required this.title,
      required this.artist,
      required this.imageUrl,
      required this.color});
}
