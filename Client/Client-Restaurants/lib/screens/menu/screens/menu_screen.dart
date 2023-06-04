import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_app_bar.dart';
import 'package:good_to_go_restaurant/screens/menu/components/drop_down_card.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/styles.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        "메뉴 관리",
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.swap_vert_rounded,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() {}),
                    controller: _textController,
                    style: AppStyle.textInTextFieldStyle,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '카테고리 추가',
                      hintStyle: AppStyle.hintTextInTextFieldStyle,
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: AppStyle.textFieldDefaultBorderStyle,
                      enabledBorder: AppStyle.textFieldDefaultBorderStyle,
                      contentPadding: const EdgeInsets.all(16).w,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    color: AppColor.primaryLightColor,
                    icon: const Icon(
                      Icons.add_rounded,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 36.h,
            ),
            Text(
              "메뉴",
              style: AppStyle.captionTextStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            const DropDownCard(),
            const DropDownCard(),
            SizedBox(
              height: 36.h,
            ),
          ],
        ),
      ),
    );
  }
}
