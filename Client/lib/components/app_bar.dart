import 'package:flutter/material.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final String appBarTitle;
  DefaultAppBar(this.appBarTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: GrayScale.g900, //change your color here
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
      title: Text(
        appBarTitle,
      ),
      titleTextStyle: FontStyle.appBarTitleStyle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
