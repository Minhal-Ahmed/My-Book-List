import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';
import 'package:flutter_application_1/OnBoarding/onboarding.dart';
import 'package:flutter_application_1/Pages/home.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("seenOnboarding") ?? false; 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    //MobileAds.instance.initialize();

  runApp(MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Book List',
      debugShowCheckedModeBanner: false,

      //Theme
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.light,
      home: onboarding ?  BookListScreen() : const OnBoarding(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(),
      ),
    );
  }
}
