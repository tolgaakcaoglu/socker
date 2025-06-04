import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socker/src/extensions/context_extensions.dart';
import 'package:socker/src/extensions/string_extensions.dart';

class Socker {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scafKey =
      GlobalKey<ScaffoldMessengerState>();
  static BuildContext context = navKey.currentState!.context;

  ThemeData get theme => context.theme;
  Brightness get brightness => context.brightness;
  bool get isDark => context.isDark;
  Color get scaffoldColor => context.backgroundColor;
  Color get primaryColor => theme.primaryColor;
  Color get placeholderColor => context.placeholderColor;
  Color get foregroundColor => context.foregroundColor;
  Color get backgroundColor => context.backgroundColor;

  Size get size => context.size!;
  double get width => context.width;
  double get height => context.height;
  double get safeHeight => context.safeHeight;

  bool get isMobile => context.isMobile;
  bool get isDesktop => context.isDesktop;
  bool get isTablet => context.isTablet;

  void get hideKeyboard => context.hideKeyboard;
  bool get isKeyboardOpened => context.isKeyboardOpened;

  String themed(String icon) => isDark ? '${icon}_dark' : icon;
  String themedInvert(String icon) => isDark ? icon : '${icon}_dark';

  String themedIconPath(String icon) =>
      isDark ? '${icon}_dark'.svgAsset : icon.svgAsset;
  String themedInvertIconPath(String icon) =>
      isDark ? icon.svgAsset : '${icon}_dark'.svgAsset;

  String themedImagePath(String path) =>
      isDark ? themed(path).imgAsset : path.imgAsset;
  String themedInvertImagePath(String path) =>
      isDark ? path.imgAsset : themed(path).imgAsset;

  Widget svgIcon(String icon) => SvgPicture.asset(icon.svgAsset);
  Widget svgIconThemed(String icon) => svgIcon(themed(icon));
  Widget svgIconThemedInvert(String icon) => svgIcon(themedInvert(icon));

  NavigatorState get navigator => context.navigator;
  CupertinoPageRoute route(Widget page) => context.route(page);
  Future go(Widget page) => context.go(page);
  Future goRemoved(Widget page) => context.goReset(page);
  void back([Object? result]) => context.back(result);

  ScaffoldFeatureController? snackBar({required String title}) =>
      context.snackBar(title: title);

  Future afterDelay({dynamic Function()? function, int? milliseconds = 250}) =>
      Future.delayed(Duration(milliseconds: milliseconds!), function);
}
