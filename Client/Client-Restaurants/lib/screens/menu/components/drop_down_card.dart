import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';

import '../components/card_item.dart';

class DropDownCard extends StatefulWidget {
  const DropDownCard({super.key});

  @override
  State<DropDownCard> createState() => _DropDownCardState();
}

class _DropDownCardState extends State<DropDownCard> {
  var _trailingIcon = const Icon(Icons.arrow_downward_rounded);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)).r,
        side: const BorderSide(width: 1, color: AppColor.g100),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        initiallyExpanded: true,
        iconColor: AppColor.g700,
        collapsedIconColor: AppColor.g700,
        leading: Padding(
          padding: EdgeInsets.only(top: 2.2.h),
          child: Icon(
            Icons.arrow_drop_down_rounded,
            size: 24.w,
          ),
        ),
        trailing: Icon(
          Icons.more_vert_rounded,
          size: 24.w,
        ),
        onExpansionChanged: (isExpanded) => setState(() => isExpanded
            ? _trailingIcon = Icon(
                Icons.arrow_drop_down_rounded,
                size: 24.w,
              )
            : _trailingIcon = Icon(
                Icons.arrow_drop_up_rounded,
                size: 24.w,
              )),
        title: Text(
          '메뉴',
          style: TextStyle(
            fontFamily: AppFont.nanumSquareNeo,
            fontSize: 12.sp,
            fontVariations: const [
              FontVariation('wght', 700),
            ],
            color: AppColor.g800,
          ),
        ),
        childrenPadding: EdgeInsets.only(
          bottom: 24.h,
          left: 16.w,
          right: 16.w,
        ),
        children: [
          const CardItem(),
          const CardItem(),
          const CardItem(),
          Container(
            width: double.infinity,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: IconButton(
              onPressed: () {},
              color: AppColor.g600,
              icon: const Icon(
                Icons.add_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
