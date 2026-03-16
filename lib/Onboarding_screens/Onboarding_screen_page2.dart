import 'package:flutter/material.dart';

class OnboardingPagetwo extends StatelessWidget {
  const OnboardingPagetwo({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: 60,bottom: 20),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text("Assign Roles.\nTrack Progress",style: TextStyle(
              fontSize: mq.width * 0.082,
              fontFamily: "Mynor",
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
            textAlign: TextAlign.center,),
          Text("Delegate tasks, set deadlines and\nkeep your entire team aligned",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "Mynor",
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,),
          SizedBox(height: 50,),
          // Image with similar height and aspect ratio
          Padding(
            padding: const EdgeInsets.only(right: 12,left: 12,top: 10),
            child: Container(
              height: mq.height * 0.314,
              width: mq.width*1,// Adjusted height for the image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Page2_image.png"),
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