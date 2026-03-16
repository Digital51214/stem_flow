import 'package:flutter/material.dart';

import 'Widgets/background.dart';
class Phasesscreen extends StatefulWidget {
  const Phasesscreen({super.key});

  @override
  State<Phasesscreen> createState() => _PhasesscreenState();
}

class _PhasesscreenState extends State<Phasesscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Center(
            child: Text("Phases Screen",style: TextStyle(
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
