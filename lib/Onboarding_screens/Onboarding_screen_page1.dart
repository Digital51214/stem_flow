import 'package:flutter/material.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return SizedBox(
      height: mq.height,
      width: mq.width,
      child: Column(
        children: [
          SizedBox(height: mq.height * 0.10),

          // ✅ Title
          Text(
            "Manage\nEvery Phase",
            style: TextStyle(
              fontSize: mq.width * 0.085,
              fontFamily: "Mynor",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: mq.height * 0.015),

          // ✅ Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.08),
            child: Text(
              "Plan, organize and track your\nSTEM racing project from design\nto competition",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: mq.width * 0.038,
                fontFamily: "Mynor",
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: mq.height * 0.06),

          // ✅ Image — full width, correct aspect ratio, no cropping
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
            child: Image.asset(
              "assets/images/Page1_image.png",
              width: mq.width * 0.90,
              height: mq.height * 0.38,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}