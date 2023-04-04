import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseOutlinedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color color;

  const BaseOutlinedButton(this.text, this.onPressed,
      {Key? key, this.color = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(330.w, 44.h),
        foregroundColor: color,
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: GrayScale.g200,
        disabledForegroundColor: GrayScale.g400,
        side: BorderSide(width: 1, color: color),
        textStyle: FontStyle.baseButtonStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6).r,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16).h,
      ),
      child: Text(text),
    );
  }
}
