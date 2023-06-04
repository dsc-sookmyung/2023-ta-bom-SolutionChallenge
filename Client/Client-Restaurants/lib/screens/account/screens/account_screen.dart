import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_app_bar.dart';
import 'package:good_to_go_restaurant/screens/account/components/account_item.dart';
import 'package:good_to_go_restaurant/utilities/styles.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  final String _version = 'v1.0.0';

  Widget _getSpacing() {
    return SizedBox(
      height: 36.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar("계정"),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              "내 정보",
              style: AppStyle.captionTextStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            AccountItem(
              text: '이메일',
              secondText: FirebaseAuth.instance.currentUser!.email!,
            ),
            _getSpacing(),
            Text(
              "계정",
              style: AppStyle.captionTextStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            GestureDetector(
              onTap: FirebaseAuth.instance.signOut,
              child: const AccountItem(
                text: '로그아웃',
              ),
            ),
            const AccountItem(
              text: '탈퇴하기',
            ),
            _getSpacing(),
            Text(
              "기타",
              style: AppStyle.captionTextStyle,
            ),
            SizedBox(
              height: 8.h,
            ),
            AccountItem(
              text: '버전',
              secondText: _version,
            ),
            const AccountItem(
              text: '자세한 어플 사용 설명 보러가기',
            ),
          ],
        ),
      )),
    );
  }
}
