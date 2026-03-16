import 'package:flutter/material.dart';

import 'Widgets/background.dart';
class Tasksscreen extends StatefulWidget {
  const Tasksscreen({super.key});

  @override
  State<Tasksscreen> createState() => _TasksscreenState();
}

class _TasksscreenState extends State<Tasksscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Center(
            child: Text("Tasks Screen",style: TextStyle(
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
