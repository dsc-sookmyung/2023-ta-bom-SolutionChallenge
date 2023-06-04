import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_to_go_restaurant/provider/user_provider.dart';
import 'package:good_to_go_restaurant/screens/account/screens/account_screen.dart';
import 'package:good_to_go_restaurant/screens/order/screens/order_screen.dart';
import 'package:good_to_go_restaurant/screens/store/screens/store_screen.dart';
import 'package:provider/provider.dart';
import '../utilities/colors.dart';

class BaseScaffold extends StatefulWidget {
  const BaseScaffold({super.key});

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int _selectedIdx = 0;

  final List<Widget> _screenList = [
    const StoreScreen(),
    const OrderScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('restaurants')
        .where("owner_uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((querySnapshot) {
      context.read<UserProvider>().setStoreId(querySnapshot.docs[0].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screenList.elementAt(_selectedIdx),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIdx,
        backgroundColor: Colors.white,
        unselectedItemColor: AppColor.g100,
        selectedItemColor: AppColor.primaryColor,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_storefront.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_storefront_filled.svg',
              ),
              label: 'store'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_receipt_long.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_receipt_long_filled.svg',
              ),
              label: 'order'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_person.svg',
              ),
              activeIcon: SvgPicture.asset(
                width: 24.w,
                'assets/icons/ic_person_filled.svg',
              ),
              label: 'account'),
        ],
      ),
    );
  }
}
