import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go_restaurant/components/base_scaffold.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _signInWithGoogle(context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.hasData) {
            return const BaseScaffold();
          } else {
            return Scaffold(
              body: TextButton(
                onPressed: () => _signInWithGoogle(context),
                style: TextButton.styleFrom(
                  minimumSize: Size(350.w, 55.h),
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8).r,
                  ),
                ),
                child: Text(
                  "구글로 로그인/회원가입",
                  style: TextStyle(
                    fontFamily: AppFont.nanumSquareNeo,
                    fontSize: 16.sp,
                    fontVariations: const [
                      FontVariation('wght', 700),
                    ],
                    color: AppColor.g900,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
