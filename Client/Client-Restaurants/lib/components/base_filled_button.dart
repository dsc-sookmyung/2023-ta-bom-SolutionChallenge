import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/styles.dart';

class BaseFilledButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool isDisable;

  const BaseFilledButton(this.text, this.onPressed,
      {Key? key, this.isDisable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: !isDisable ? onPressed : null,
      style: TextButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        disabledBackgroundColor: AppColor.g200,
        foregroundColor: Colors.white,
        disabledForegroundColor: AppColor.g400,
        textStyle: AppStyle.buttonTextStyle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10).r,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16).h,
      ),
      child: Text(text),
    );
  }
}
