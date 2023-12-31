import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';

/// A function that builds a [PageView] lazily.
typedef PageView PageViewBuilder(
    BuildContext context, PageVisibilityResolver visibilityResolver);

class PageVisibilityResolver {
  PageVisibilityResolver({
    required ScrollMetrics metrics,
    required double viewPortFraction,
}):this._pageMetrics = metrics, this._viewPortFraction = viewPortFraction;


   ScrollMetrics _pageMetrics;
   double _viewPortFraction;

/// Calculates visibility information for the page at [pageIndex].
/// Used inside PageViews' itemBuilder, but can be also used in a
/// simple PageView that simply has an array of children passed to it.

  PageVisibility resolvePageVisibility(int pageIndex) {
    final double pagePosition = _calculatePagePosition(pageIndex);
    final double visiblePageFraction =
    _calculateVisiblePageFraction(pageIndex, pagePosition);

    return PageVisibility(
      visibleFraction: visiblePageFraction,
      pagePosition: pagePosition,
    );
  }
  double _calculateVisiblePageFraction(int index, double pagePosition) {
    if (pagePosition > -1.0 && pagePosition <= 1.0) {
      return 1.0 - pagePosition.abs();
    }

    return 0.0;
  }
  double _calculatePagePosition(int index) {
    final double viewPortFraction = _viewPortFraction ?? 1.0;
    final double pageViewWidth =
        (_pageMetrics?.viewportDimension ?? 1.0) * viewPortFraction;
    final double pageX = pageViewWidth * index;
    final double scrollX = (_pageMetrics?.pixels ?? 0.0);
    final double pagePosition = (pageX - scrollX) / pageViewWidth;
    final double safePagePosition = !pagePosition.isNaN ? pagePosition : 0.0;

    if (safePagePosition > 1.0) {
      return 1.0;
    } else if (safePagePosition < -1.0) {
      return -1.0;
    }

    return safePagePosition;
  }


  // PageVisibilityResolver();
}

class PageVisibility{
  PageVisibility({
    required this.pagePosition,
    required this.visibleFraction,
});
  /// How much of the page is currently visible, between 0.0 and 1.0.
  /// For example, if only the half of the page is visible, the value of this is going to be 0.5.
  late final double visibleFraction;
  /// Tells the position of this page, relative to being visible in
  /// a "non-dragging" position, between -1.0 and 1.0.
  /// If the page is fully out of view on the right, this value is going to be 1.0.
  late final double pagePosition;
}

/// A widget for getting useful information about a pages' position
/// and how much of it is visible in a PageView.
class PageTransformer extends StatefulWidget{
  const PageTransformer({Key? key, required this.pageViewBuilder}) : super(key: key);

  final PageViewBuilder pageViewBuilder;

  @override
  _PageTransformerState createState() => _PageTransformerState();
}

class _PageTransformerState extends State<PageTransformer>{
   late PageVisibilityResolver _visibilityResolver;

   /// 在调用时，主文件page_transformer调用时初始化
  @override
  void initState() {
    super.initState();
    // 在 initState 中初始化 visibilityResolver
    _visibilityResolver = PageVisibilityResolver(
      metrics: PageMetrics(
        minScrollExtent: 0.0, // 设置最小滚动范围
        maxScrollExtent: 1000.0, // 设置最大滚动范围
        pixels: 500.0, // 设置当前位置（像素）
        viewportDimension: 200.0, // 设置视口尺寸
        axisDirection: AxisDirection.down, // 设置页面滚动方向
        viewportFraction: 0.8, // 设置视口的分数
        devicePixelRatio: 1.0, // 设置设备像素比率
      ),
      viewPortFraction: 0.8, // 设置视口分数，根据实际需要调整
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageView = widget.pageViewBuilder(
        context,
        _visibilityResolver
    );

    final controller = pageView.controller;
    final viewPortFraction = controller.viewportFraction;

    return NotificationListener(
      onNotification: (ScrollNotification notification){
        setState(() {
          _visibilityResolver = PageVisibilityResolver(
            metrics: notification.metrics,
            viewPortFraction: viewPortFraction,
          );
        });
        return true;
      },
      // child: pageView,
      child: Scaffold(
        // body: pageView,
        body: Column(
          children: [
            Expanded(child: pageView,),
            PageViewIndicator(
              length: 3,
              currentIndex: _getCurrentPageIndex(),
              // alignment: Axis.horizontal,
              // reverse:true,
              // otherItemWidth: 20,
              // otherItemHeight: 8,
            ),
            Container( // 包含login按钮
              padding: const EdgeInsets.only(top: 20.0),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.09,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  primary: const Color(0xFF827397),
                  elevation: 5, // 设置按钮阴影的值
                  shadowColor: Colors.grey, // 设置阴影的颜色
                ),// style
                onPressed: () => Navigator.of(context).pushNamed("login"),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }// return ;

   int _getCurrentPageIndex() {
     // 获取页面的位置信息
     final currentPagePosition = _visibilityResolver.resolvePageVisibility(1).pagePosition;
     // 计算当前页面的索引
     // 假设你有3个页面，分别位于 -1.0、0.0 和 1.0 位置
     if (currentPagePosition >= 0.5) {
       return 0; // 第一个页面的索引为 0
     } else if (currentPagePosition > -0.5 && currentPagePosition < 0.5) {
       return 1; // 第二个页面的索引为 1
     } else {
       return 2; // 第三个页面的索引为 2
     }
   }

}