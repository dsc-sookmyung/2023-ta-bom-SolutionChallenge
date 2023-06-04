import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:good_to_go/screens/login/screens/login_screen.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';
import 'provider/cart_provider.dart';
import 'package:good_to_go/provider/user_provider.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: nanumSquareNeo,
            primaryColor: primaryColor,
            primaryColorLight: primaryLightColor,
            scaffoldBackgroundColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: child,
        );
      },
      child: const LoginPage(),
    );
  }
}
