import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:good_to_go/utilities/variables.dart';

import 'package:good_to_go/screens/login/screens/userLocation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPageIndex = 0;

  void _goToNextPage() {
    if (_currentPageIndex + 1 == Variables.onboarindgTexts.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLocationPage()),
      );
    } else {
      _pageController.animateToPage(_currentPageIndex + 1,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Variables.onboarindgTexts.length,
            itemBuilder: (context, index) {
              return Onboarding(
                title: Variables.onboarindgTexts[index]["title"]!,
                content: Variables.onboarindgTexts[index]["content"]!,
                imagePath: Variables.onboarindgTexts[index]["imgPath"]!,
              );
            },
            onPageChanged: (int pageIndex) {
              setState(() {
                _currentPageIndex = pageIndex;
              });
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          margin: EdgeInsets.only(bottom: 32.h),
          child: BottomAppBar(
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    Variables.onboarindgTexts.length,
                    (index) => _currentPageIndex == index
                        ? Container(
                            margin: EdgeInsets.only(right: 6.w),
                            width: 16.w,
                            height: 7.w,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.r))))
                        : Container(
                            margin: EdgeInsets.only(right: 6.w),
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: GrayScale.g200),
                          ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: Size(120.w, 44.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPageIndex == 3 ? '시작하기' : '건너뛰기',
                    style: FontStyle.baseButtonStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Onboarding extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;

  const Onboarding({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SvgPicture.asset(
            imagePath,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                Text(
                  title,
                  style: FontStyle.onboardingTitleTextStyle,
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  content,
                  style: FontStyle.onboardingContentTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        //SizedBox(height: 37.94),
      ],
    );
  }
}
