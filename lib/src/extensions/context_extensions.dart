import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socker/src/widgets/macos_route_animation.dart';

import '../../socker.dart';

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  double get safeHeight => height - (viewInsets.bottom + viewPadding.top);

  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  bool get isMobile => width < 768;
  bool get isDesktop => width > 1200;
  bool get isTablet => !isMobile && !isDesktop;

  double get containerWidth => isDesktop ? 1024 : width;
  double get defaultContainerPadding => isDesktop ? 0 : 12;
  double get defaultPadding => 12;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  Brightness get brightness => theme.brightness;

  bool get isDark => brightness == Brightness.dark;
  bool get isLight => !isDark;

  Color get backgroundColor => isDark ? Colors.black : Colors.white;
  Color get foregroundColor => isDark ? Colors.white : Colors.black;
  Color get layerColor => isDark ? Colors.grey.shade900 : Colors.grey.shade50;
  Color get subtextColor => isDark ? Colors.grey : Colors.grey;
  Color get primaryColor => isDark ? Colors.purple : Colors.blue;
  Color get placeholderColor =>
      isDark ? Colors.grey.shade900 : Colors.grey.shade50;

  FocusScopeNode get focusScope => FocusScope.of(this);
  void get hideKeyboard => focusScope.unfocus();
  bool get isKeyboardOpened => viewInsets.bottom > 0;

  Widget indicator({
    double? value,
    Color? color,
    double? strokeWidth,
    Size? size,
  }) => CircularProgressIndicator(
    strokeWidth: strokeWidth ?? 1,
    color: color ?? foregroundColor,
    value: value,
  ).size(w: size?.width ?? 24, h: size?.height ?? 24);

  Widget imageNetwork({
    required String path,
    bool isFitted = true,
    double radius = 0,
  }) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: isFitted ? BoxFit.cover : BoxFit.contain,
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          color: context.placeholderColor,
          child: context.indicator(value: progress.progress).center,
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          color: context.placeholderColor,
          child: const Icon(Icons.error).center,
        );
      },
    ).radius(radius);
  }

  CachedNetworkImageProvider imageNetworkProvider({required String path}) {
    return CachedNetworkImageProvider(
      path,
      errorListener: (p0) => Container(
        color: placeholderColor,
        child: const Icon(Icons.error).center,
      ),
    );
  }

  NavigatorState get navigator => Navigator.of(this);
  PageRouteBuilder route(Widget p) => MacosRoute(child: p);
  Future go(Widget p) => navigator.push(route(p));
  Future goReset(Widget p) =>
      navigator.pushAndRemoveUntil(route(p), (_) => false);
  void back([dynamic value]) => navigator.pop(value);

  ScaffoldFeatureController? snackBar({required String title}) {
    Socker.scafKey.currentState?.clearSnackBars();
    SnackBar sn = SnackBar(
      content: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      backgroundColor: primaryColor,
    );
    return Socker.scafKey.currentState?.showSnackBar(sn);
  }
}
