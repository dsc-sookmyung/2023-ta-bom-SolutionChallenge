import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/variables.dart';

class PrepareContainer extends StatelessWidget {
  late String name;
  final int container;

  PrepareContainer(
    this.container, {
    super.key,
  }) {
    name = Variables.prepareContainerTexts[container]["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          Variables.prepareContainerTexts[container]["imgPath"],
          width: 48.w,
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: nanumSquareNeo,
            fontSize: 10.sp,
            fontVariations: const [
              FontVariation('wght', 700),
            ],
            color: GrayScale.g500,
          ),
        ),
      ],
    );
  }
}
