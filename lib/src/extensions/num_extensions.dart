import 'package:flutter/material.dart';

extension NumExtensions on num {
  Widget get width => SizedBox(width: toDouble());
  Widget get height => SizedBox(height: toDouble());

  String countShorter() {
    int viewCount = toInt();
    if (viewCount < 1000) {
      return viewCount.toString();
    } else if (viewCount < 1000000) {
      return '${(viewCount / 1000).toStringAsFixed(0)} bin';
    } else {
      return '${(viewCount / 1000000).toStringAsFixed(0)} ml';
    }
  }
}
