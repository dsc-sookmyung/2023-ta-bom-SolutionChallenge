import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:good_to_go/screens/account/screens/account_screen.dart';
import 'package:good_to_go/screens/home/screens/home_screen.dart';
import 'package:good_to_go/screens/order/screens/order_screen.dart';
import 'package:good_to_go/screens/recap/screens/recap_screen.dart';
import 'package:good_to_go/utilities/colors.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({super.key});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int selectedIndex = 0;

  List<Widget> pageList = [
    const HomeScreen(),
    const OrderScreen(),
    RecapScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pageList.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: GrayScale.g600,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/home.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/home_filled.svg',
              ),
              label: 'home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/order_approve.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/order_approve_filled.svg',
              ),
              label: 'order'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/analytics.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/analytics_filled.svg',
              ),
              label: 'recap'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/person.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/navigation/person_filled.svg',
              ),
              label: 'account'),
        ],
      ),
    );
  }
}
