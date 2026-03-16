import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/Background2.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mqsize = MediaQuery.of(context).size;
    return Scaffold(
      body: Bg2(child: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(height: 18,),
              Row(
                children: [
                  BackCircle(onTap: (){
                    Navigator.pop(context);
                  }),
                  SizedBox(width: 15,),
                  Text("Privacy Policy",style: TextStyle(
                    fontSize: 15.5,
                    fontFamily: "Mynor",
                    color: Colors.white,
                  ),),
                  SizedBox(width: mqsize.width*0.19,),
                  Container(
                    height: 44,
                    width: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/Logo.png")),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15,),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Mynor",
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                    fontFamily: "Mynor",
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in mattis ante. Nam ac diam quis dolor lobortis euismod et eget nunc. Curabitur ullamcorper, nibh vel ultricies commodo, libero tortor viverra velit, sed elementum nunc purus sed ante. Donec sit amet bibendum tellus. Integer vehicula est quis mauris euismod, malesuada c.',
                style: TextStyle(
                  fontSize: 16,
                    fontFamily: "Mynor",
                    height: 1.6,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ))),
    );
  }
}
