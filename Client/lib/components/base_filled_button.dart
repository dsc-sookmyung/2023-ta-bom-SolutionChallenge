import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseFilledButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  bool isDisable;

  BaseFilledButton(this.text, this.onPressed,
      {Key? key, this.isDisable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: !isDisable ? onPressed : null,
      style: TextButton.styleFrom(
        minimumSize: Size(330.w, 44.h),
        backgroundColor: primaryColor,
        disabledBackgroundColor: GrayScale.g200,
        foregroundColor: Colors.white,
        disabledForegroundColor: GrayScale.g400,
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
