import 'package:flutter/material.dart';

import 'Widgets/background.dart';
class Morescreen extends StatefulWidget {
  const Morescreen({super.key});

  @override
  State<Morescreen> createState() => _MorescreenState();
}

class _MorescreenState extends State<Morescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Center(
            child: Text("More Screen",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "Mynor",
              color: Colors.white,
            ),),
          ),
        ),
      ),
    );
  }
}
