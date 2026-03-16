import 'package:flutter/material.dart';

class OnboardingPagethree extends StatelessWidget {
  const OnboardingPagethree({super.key});

  @override
  Widget build(BuildContext context) {
    final mqsize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 60,bottom: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text("Smarter\nDecisions with AI",style: TextStyle(
              fontSize: mqsize.width * 0.075,
              fontWeight: FontWeight.bold,
              fontFamily: "Mynor",
              color: Colors.white
          ),
            textAlign: TextAlign.center,),
          Text("Get performance insights and\nmonitor your team budget in real\ntime",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Mynor",
              fontSize: 13,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,),
          SizedBox(height: 30,),
          // Image with similar height and aspect ratio
          Padding(
            padding: const EdgeInsets.only(right: 15.0,left: 15),
            child: Container(
              height: mqsize.height * 0.35,
              width: mqsize.width*1,// Adjusted height for the image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Page3_image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}