import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socker/src/extensions/context_extensions.dart';
import 'package:socker/src/extensions/string_extensions.dart';

class Socker {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scafKey =
      GlobalKey<ScaffoldMessengerState>();
  static BuildContext context = navKey.currentState!.context;

  static ThemeData get theme => context.theme;
  static Brightness get brightness => context.brightness;
  static bool get isDark => context.isDark;
  static Color get scaffoldColor => context.backgroundColor;
  static Color get primaryColor => theme.primaryColor;
  static Color get placeholderColor => context.placeholderColor;
  static Color get foregroundColor => context.foregroundColor;
  static Color get backgroundColor => context.backgroundColor;

  static Size get size => context.size!;
  static double get width => context.width;
  static double get height => context.height;
  static double get safeHeight => context.safeHeight;

  static bool get isMobile => context.isMobile;
  static bool get isDesktop => context.isDesktop;
  static bool get isTablet => context.isTablet;

  static void get hideKeyboard => context.hideKeyboard;
  static bool get isKeyboardOpened => context.isKeyboardOpened;
  static String themed(String icon) => isDark ? '${icon}_dark' : icon;
  static String themedInvert(String icon) => isDark ? icon : '${icon}_dark';

  static String themedIconPath(String icon) =>
      isDark ? '${icon}_dark'.svgAsset : icon.svgAsset;
  static String themedInvertIconPath(String icon) =>
      isDark ? icon.svgAsset : '${icon}_dark'.svgAsset;

  static String themedImagePath(String path) =>
      isDark ? themed(path).imgAsset : path.imgAsset;
  static String themedInvertImagePath(String path) =>
      isDark ? path.imgAsset : themed(path).imgAsset;

  static Widget svgIcon(String icon) => SvgPicture.asset(icon.svgAsset);
  static Widget svgIconThemed(String icon) => svgIcon(themed(icon));
  static Widget svgIconThemedInvert(String icon) => svgIcon(themedInvert(icon));

  static NavigatorState get navigator => context.navigator;
  static PageRoute route(
    Widget page, {
    PageTransitionType type = PageTransitionType.ios,
  }) => context.route(page, type);
  static Future go(Widget page, {PageTransitionType? type}) => context.go(page);
  static Future goRemoved(Widget page, {PageTransitionType? type}) =>
      context.goReset(page);
  static void back([Object? result]) => context.back(result);

  static ScaffoldFeatureController? snackBar({required String title}) =>
      context.snackBar(title: title);

  static Future afterDelay({
    dynamic Function()? function,
    int? milliseconds = 250,
  }) => Future.delayed(Duration(milliseconds: milliseconds!), function);
}
