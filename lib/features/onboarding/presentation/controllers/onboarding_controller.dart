import 'package:flutter/widgets.dart';

class OnboardingController {
  final PageController pageController  = PageController();

  int currentPage = 0;

  void nextPage({
    required int totalPages,
    required VoidCallback onFinished,
  }){
    if(currentPage < totalPages - 1){
      pageController.nextPage(
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
        );
    }else{
      onFinished();
    }
  }

  void updatePage(int index){
    currentPage = index;
  }

  void dispose(){
    pageController.dispose();
  }
}