import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:good_to_go_restaurant/utilities/colors.dart';
import 'package:good_to_go_restaurant/utilities/fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'provider/user_provider.dart';
import 'screens/login/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Good To Go for Manager',
          theme: ThemeData(
            fontFamily: AppFont.nanumSquareNeo,
            primaryColor: AppColor.primaryColor,
            primaryColorLight: AppColor.primaryLightColor,
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
      child: const LoginScreen(),
    );
  }
}
