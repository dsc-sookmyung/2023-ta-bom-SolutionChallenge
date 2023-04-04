import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:good_to_go/provider/user_provider.dart';
import 'package:good_to_go/screens/login/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_to_go/screens/login/screens/userLocation_screen.dart';

import 'package:simple_animations/simple_animations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .signInWithGoogle();
      final User? user = Provider.of<UserProvider>(context, listen: false).user;
      if (user != null) {
        // completed onboarding???
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool hasCompletedOnboarding =
            prefs.getBool('hasCompletedOnboarding') ?? false;
        if (!hasCompletedOnboarding) {
          if (!mounted) {
            return; // Avoid calling setState on a widget that is no longer mounted
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
          // set the onboarding status to true
          await prefs.setBool('hasCompletedOnboarding', true);
        } else {
          if (!mounted) {
            return; // Avoid calling setState on a widget that is no longer mounted
          }
          Navigator.pushReplacement(
            context,
            //MaterialPageRoute(builder: (context) => const BaseScaffold()),
            MaterialPageRoute(builder: (context) => const UserLocationPage()),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('로그인에 실패했습니다.')));
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 120.h),
              child: Stack(
                children: [
                  LoopAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 360.0),
                    duration: const Duration(seconds: 400),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value,
                        child: child,
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/images/earth_body.svg',
                      width: 300.w,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/earth_face.svg',
                    width: 300.w,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  '반갑습니다!',
                  style: TextStyle(
                    fontFamily: nanumSquareNeo,
                    fontSize: 24.sp,
                    height: 1.50,
                    color: GrayScale.g800,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '제로웨이스트 포장 주문 앱\nGood To Go와 함께\n환경을 지키러 가볼까요?',
                  style: TextStyle(
                    fontFamily: nanumSquareNeo,
                    fontSize: 15.sp,
                    height: 1.50,
                    color: GrayScale.g700,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                BaseFilledButton(
                  'Sign in with Google',
                  () async {
                    await _handleSignIn(context);
                  },
                ),
                SizedBox(
                  height: 32.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
