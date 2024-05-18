import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/color.dart';
import 'package:flutter_application_1/OnBoarding/onboardingitems.dart';
import 'package:flutter_application_1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final controller = OnBoardingItems();
  final pageController = PageController();

  bool isLastPage=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child:isLastPage?getStarted(): Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Skip Button 
            TextButton(
              onPressed: ()=>pageController.jumpToPage(controller.items.length-1), 
              child: const Text("Skip")),
        
            //indicator
            SmoothPageIndicator(
              controller: pageController,
              count: controller.items.length,
              onDotClicked: ((index) => pageController.animateToPage(index,
              duration: const Duration(milliseconds: 600), curve: Curves.easeIn)),
              effect:const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: primaryColor,//.fromARGB(255, 82, 247, 167)
              ) ,
              ),
        
        
            //Next Button 
              TextButton(
              onPressed: ()=>pageController.nextPage(
                duration:const Duration(milliseconds: 600),
                curve: Curves.easeIn
                ), 
              child: const Text("Next")),
          ],
        ),
      ),
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: PageView.builder(
        onPageChanged: (index)=>setState(() =>isLastPage=controller.items.length-1==index),
        itemCount: (controller.items.length),
        controller: pageController,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(controller.items[index].image),
              SizedBox(height: 5),
              Text(controller.items[index].title),
              SizedBox(height: 10),
              Text(
                controller.items[index].descriptions,
                style: const TextStyle(
                  color: Colors.grey, 
                  fontSize: 15
                  ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    )
    );
  }

  //Get started
  Widget getStarted(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryColor
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: ()async{
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            //After we press get started button this onboarding value become true
            // same key
            if(!mounted)return;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
          },
          child: const Text("Get started",style: TextStyle(color: Colors.white),)),
    );
}
}
