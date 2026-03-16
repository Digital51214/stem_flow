import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stemflow/Onboarding_screens/Onboarding_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final mqsize = MediaQuery.of(context).size;
  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainOnboardingScreen()),
          (Route<dynamic>route)=>false);
    } );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mqsize.height*1,
        width: mqsize.width*1,
        decoration: BoxDecoration(
          image:DecorationImage(image: AssetImage("assets/images/BG.png"),fit: BoxFit.cover),
            
        ),
      ),
    );
  }
}
