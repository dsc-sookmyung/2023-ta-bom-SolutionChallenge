import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Functions {
  static Widget? getContainerSvg(int container, double width) {
    if (container == 1) {
      return SvgPicture.asset(width: width, "assets/icons/small_container.svg");
    } else if (container == 2) {
      return SvgPicture.asset(
          width: width, "assets/icons/medium_container.svg");
    } else if (container == 3) {
      return SvgPicture.asset(width: width, "assets/icons/large_container.svg");
    } else if (container == 4) {
      return SvgPicture.asset(width: width, "assets/icons/tumbler.svg");
    } else if (container == 5) {
      return SvgPicture.asset(width: width, "assets/icons/sauce_container.svg");
    } else if (container == 6) {
      return SvgPicture.asset(width: width, "assets/icons/pen.svg");
    }
    return null;
  }
}
