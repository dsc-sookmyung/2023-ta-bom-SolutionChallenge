import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/functions.dart';
import 'package:intl/intl.dart';

class Option extends StatefulWidget {
  final String id, name;
  final int container, price;
  bool isSelected;
  bool isRadius;
  final Function()? callback;

  Option({
    super.key,
    required this.id,
    required this.name,
    required this.container,
    required this.price,
    required this.callback,
    this.isSelected = false,
    this.isRadius = false,
  });

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  var f = NumberFormat('###,###,###,###');

  TextStyle getOptionTextStyle(bool isSelected) {
    return TextStyle(
      fontFamily: nanumSquareNeo,
      fontSize: 12.sp,
      fontVariations: const [
        FontVariation('wght', 600),
      ],
      color: isSelected ? primaryColor : GrayScale.g600,
    );
  }

  SvgPicture getIcon(bool isSelected, bool isRadius) {
    if (isSelected && isRadius) {
      return SvgPicture.asset(
        width: 24.w,
        height: 24.w,
        'assets/icons/radio_button_checked.svg',
      );
    } else if (isSelected && !isRadius) {
      return SvgPicture.asset(
        width: 24.w,
        height: 24.w,
        'assets/icons/check_box.svg',
      );
    } else if (!isSelected && isRadius) {
      return SvgPicture.asset(
        width: 24.w,
        height: 24.w,
        'assets/icons/radio_button_unchecked.svg',
      );
    } else {
      return SvgPicture.asset(
        width: 24.w,
        height: 24.w,
        'assets/icons/check_box_outline_blank.svg',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected ? primaryLightColor : GrayScale.g100,
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 17, 20, 17).w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getIcon(widget.isSelected, widget.isRadius),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    widget.name,
                    style: getOptionTextStyle(widget.isSelected),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  if (widget.container != 0)
                    Functions.getContainerSvg(widget.container, 20.w)!,
                ],
              ),
              Text(
                '${f.format(widget.price)}원',
                style: getOptionTextStyle(widget.isSelected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
