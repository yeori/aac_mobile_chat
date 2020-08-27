import 'package:flutter/material.dart';

class Decorations {
  static roundedBox(
      {num size = 1.0,
      borderColor = Colors.black,
      radius = 4.0,
      backgroundColor = Colors.transparent}) {
    return BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(color: borderColor, width: size));
  }

  static rounded({tl: 0.0, tr: 0.0}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
      ),
    );
  }
}
