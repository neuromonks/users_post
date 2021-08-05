import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:users_post/models/ModelProvider.dart';
import 'package:users_post/modules/home/ScreenHome.dart';
import 'package:users_post/modules/users/ScreenDisplayUsers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModelProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AnimatedSplashScreen(
          splash: 'assets/images/flutter.png',
          nextScreen: ScreenHome(),
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.rightToLeft,
        ),
      ),
    );
  }
}
