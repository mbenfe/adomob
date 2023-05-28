import 'package:flutter/material.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

double getBodyHeight(BuildContext context) {
  double height = MediaQuery.of(context).size.height - // total height
      kToolbarHeight - // top AppBar height
      MediaQuery.of(context).padding.top - // top padding
      MediaQuery.of(context).padding.bottom -
      kBottomNavigationBarHeight;
  return height;
}
