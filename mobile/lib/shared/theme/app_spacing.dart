import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(20));
  static const BorderRadius controlRadius =
      BorderRadius.all(Radius.circular(16));

  static const EdgeInsets pagePadding = EdgeInsets.all(md);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets compactPadding = EdgeInsets.all(sm);
}
