import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import '../utilities/styles.dart';

class BaseAppBar extends StatelessWidget with PreferredSizeWidget {
  final String appBarTitle;
  final int height = 48;
  final List<Widget>? actions;

  BaseAppBar(
    this.appBarTitle, {
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height.h,
      title: Text(
        appBarTitle,
      ),
      titleTextStyle: AppStyle.appBarTitleTextStyle,
      actions: actions,
      actionsIconTheme: const IconThemeData(
        color: AppColor.g800,
      ),
      iconTheme: IconThemeData(
        color: AppColor.g800,
        size: 24.w,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.h);
}
