import 'package:flutter_application_1/OnBoarding/onboardinginfo.dart';

class OnBoardingItems{
  List<OnBoardingInfo> items = [
    OnBoardingInfo(
      title: "Welcome to TheBookList", 
      descriptions: "Explore a vast collection of books from different genres. Find your next great read with ease.", 
      image: "assets/gifs/Gif1.gif",
      ),

      OnBoardingInfo(
      title: "Search & Browse", 
      descriptions: "Use our powerful search to find specific books and discover your new favorites.", 
      image: "assets/gifs/Gif2.gif",
      ),

      OnBoardingInfo(
      title: "Review & Share", 
      descriptions: "Write reviews and rate books. Track your reading journey effortlessly.", 
      image: "assets/gifs/Gif3.gif",
      ),
  ];
}