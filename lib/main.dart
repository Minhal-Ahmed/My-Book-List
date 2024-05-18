import 'package:flutter/material.dart';
import 'package:flutter_application_1/OnBoarding/onboarding.dart';
import 'package:flutter_application_1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs=await SharedPreferences.getInstance();
  final onboarding=prefs.getBool("Onoarding")??false;

  runApp(MyApp(onboarding:onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key,required this.onboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      //Theme
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 138, 243, 192))
        
      ),
      //darkTheme: ThemeData(brightness: Brightness.dark),
      //themeMode: ThemeMode.dark,
      home:onboarding?Home(): OnBoarding(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
        
        ),
      ),
    );
  }
}
