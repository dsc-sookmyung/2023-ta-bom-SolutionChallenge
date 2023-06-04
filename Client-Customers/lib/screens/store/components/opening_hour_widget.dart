import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpeningHourWidget extends StatelessWidget {
  final List<dynamic> openingHours;
  final List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

  OpeningHourWidget(this.openingHours, {Key? key}) : super(key: key);

  int getDay() {
    var now = DateTime.now();
    return now.weekday - 1;
  }

  bool isToday(int day) {
    final today = getDay();

    if (today == day) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < days.length; i++)
          OpeningHour(
            days[i],
            openingHours[i],
            isToday(i),
          ),
      ],
    );
  }
}

class OpeningHour extends StatelessWidget {
  final dynamic day, time;
  final String closed = "휴무";
  final bool isToday;
  const OpeningHour(this.day, this.time, this.isToday, {Key? key})
      : super(key: key);

  String formatTime(String time) {
    if (time == closed) {
      return '$time\n';
    }
    var times = time.split(' ~ ');
    return '${times[0]}\n${times[1]}';
  }

  Color getBackgroundColor() {
    if (isToday) {
      return primaryColor;
    } else if (time != closed) {
      return GrayScale.g200;
    } else {
      return GrayScale.g400;
    }
  }

  Color getDayTextColor() {
    if (isToday) {
      return Colors.white;
    } else if (time != closed) {
      return GrayScale.g800;
    } else {
      return GrayScale.g200;
    }
  }

  Color getTimeTextColor() {
    if (isToday) {
      return Colors.white;
    } else if (time != closed) {
      return GrayScale.g600;
    } else {
      return GrayScale.g200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        width: 45.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          borderRadius: const BorderRadius.all(Radius.circular(6)).r,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontFamily: nanumSquareNeo,
                fontSize: 12.sp,
                fontVariations: const [
                  FontVariation('wght', 500),
                ],
                color: getDayTextColor(),
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              formatTime(time),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: nanumSquareNeo,
                fontSize: 8.sp,
                height: 1.25,
                fontVariations: const [
                  FontVariation('wght', 600),
                ],
                color: getTimeTextColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
