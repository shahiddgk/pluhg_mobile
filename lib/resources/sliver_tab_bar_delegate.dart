import 'package:flutter/material.dart';

class PluhgSliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  PluhgSliverTabBarDelegate({
    required this.tabBar,
    required this.width,
    required this.color,
  });

  final Widget tabBar;
  final double width;
  final Color color;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: Row(children: [Expanded(child: tabBar)]),
      height: 37.99,
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(59)),
      alignment: Alignment.center,
    );
  }

  @override
  bool shouldRebuild(PluhgSliverTabBarDelegate oldDelegate) {
    return true;
  }
}
