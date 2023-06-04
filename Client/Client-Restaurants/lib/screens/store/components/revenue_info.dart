import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:intl/intl.dart';

import 'info_scaffold.dart';

class RevenueInfo extends StatelessWidget {
  final String caption;
  final String imgPath;
  final num profit;

  final format = NumberFormat('###,###,###,###');

  RevenueInfo({
    super.key,
    required this.profit,
    required this.imgPath,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColor.g100,
          ),
          borderRadius: BorderRadius.circular(12).r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 18.w),
        child: Row(children: [
          Image.asset(
            imgPath,
            width: 40.w,
          ),
          SizedBox(
            width: 16.w,
          ),
          InfoScaffold(caption: caption, text: '${format.format(profit)}원'),
        ]),
      ),
    );
  }
}
