import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget size({double? h, double? w}) =>
      SizedBox(width: w, height: h, child: this);
  Widget padAll(double p) => Padding(padding: EdgeInsets.all(p), child: this);
  Widget padHor(double p) => Padding(
    padding: EdgeInsets.symmetric(horizontal: p),
    child: this,
  );
  Widget padVer(double p) => Padding(
    padding: EdgeInsets.symmetric(vertical: p),
    child: this,
  );
  Widget padOnly({double l = 0, double r = 0, double t = 0, double b = 0}) =>
      Padding(
        padding: EdgeInsets.only(bottom: b, left: l, right: r, top: t),
        child: this,
      );
  Widget opac(double i) => Opacity(opacity: i, child: this);
  Widget radius(double r) =>
      ClipRRect(borderRadius: BorderRadius.circular(r), child: this);
  Widget radiusVert({double t = 0, double b = 0}) => ClipRRect(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(b),
      top: Radius.circular(t),
    ),
    child: this,
  );

  Widget scrolling({
    ScrollPhysics? physics,
    Axis? axis,
    ScrollController? controller,
  }) => SingleChildScrollView(
    controller: controller,
    physics: physics,
    scrollDirection: axis ?? Axis.vertical,
    child: this,
  );

  Widget get center => Center(child: this);
  Widget get alignBC => Align(alignment: Alignment.bottomCenter, child: this);
  Widget get alignBL => Align(alignment: Alignment.bottomLeft, child: this);
  Widget get alignBR => Align(alignment: Alignment.bottomRight, child: this);
  Widget get alignTC => Align(alignment: Alignment.topCenter, child: this);
  Widget get alignTL => Align(alignment: Alignment.topLeft, child: this);
  Widget get alignTR => Align(alignment: Alignment.topRight, child: this);
  Widget get alignC => Align(alignment: Alignment.center, child: this);
  Widget get alignCR => Align(alignment: Alignment.centerRight, child: this);
  Widget get alignCL => Align(alignment: Alignment.centerLeft, child: this);
}
