import 'package:flutter/material.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:good_to_go/screens/account/screens/changeprofile_screen.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/screens/login/screens/login_screen.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userPhotoURL = userProvider.userPhotoURL;
    print('userPhotoURL: $userPhotoURL');

    return Scaffold(
      appBar: DefaultAppBar('계정'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(userProvider.userPhotoURL ??
                      'https://via.placeholder.com/150?text=User+Image'),
                  key: UniqueKey(),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        userProvider.userName ?? '',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontVariations: const [
                            FontVariation('wght', 700),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 100.w,
                        height: 36.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeProfileScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GrayScale.g200,
                            elevation: 0,
                          ),
                          child: const Text(
                            '프로필 수정',
                            style: TextStyle(
                              fontSize: 10,
                              color: GrayScale.g800,
                              fontVariations: const [
                                FontVariation('wght', 700),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 36.h),
            Text(
              '내 정보',
              style: FontStyle.captionStyle,
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 44.h,
              child: Row(
                children: [
                  Text(
                    '이메일',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontVariations: const [
                        FontVariation('wght', 500),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    userProvider.userEmail ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: primaryColor,
                      fontVariations: const [
                        FontVariation('wght', 700),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              '계정',
              style: FontStyle.captionStyle,
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 44.h,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        userProvider.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontVariations: const [
                            FontVariation('wght', 500),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              '소개',
              style: FontStyle.captionStyle,
            ),
            SizedBox(height: 6.h),
            SizedBox(
              height: 44.h,
              child: GestureDetector(
                onTap: () {
                  launch('https://www.notion.so/Good-To-Go-69954af1c38544c59ef2ffae7c8cf2a2'); // Replace with your URL
                },
                child: Row(
                  children: [
                    Text(
                      'GOOD TO GO에 대해서',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontVariations: const [
                          FontVariation('wght', 500),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(
              height: 44.h,
              child: Row(
                children: [
                  Text(
                    '버전 ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontVariations: const [
                        FontVariation('wght', 500),
                      ],
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '1.0',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: GrayScale.g400,
                      fontVariations: const [
                        FontVariation('wght', 500),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}