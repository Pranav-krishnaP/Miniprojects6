import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

@override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/agro.png',
      nextScreen: MaterialApp(),
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.scale,
    );
  }