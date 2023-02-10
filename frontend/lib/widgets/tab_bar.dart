import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';

class BingoTabBar extends StatelessWidget {
  const BingoTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContainedTabBarView(
        tabs: const [
          Tab(
            icon: Icon(
              Icons.format_color_fill_rounded,
              color: Colors.black,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.draw_outlined,
              color: Colors.black,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.font_download,
              color: Colors.black,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.black,
            ),
          ),
        ],
        views: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.amber),
          Container(color: Colors.black),
        ],
        onChange: (index) => print(index),
      ),
    );
  }
}
