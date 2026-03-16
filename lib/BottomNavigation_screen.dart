import 'package:flutter/material.dart';
import 'package:stemflow/HomeScreen.dart';
import 'package:stemflow/MoreScreen.dart';
import 'package:stemflow/PhasesScreen.dart';
import 'package:stemflow/TasksScreen.dart';
import 'package:stemflow/Widgets/CustomBottomNavBar.dart';

final List<Widget> pages = [
  HomeScreen(),
  Tasksscreen(),
  Scaffold(
    body: Center(
      child: Text("Schedule", style: TextStyle(fontSize: 20,
        fontFamily: "Mynor",
      )),
    ),
  ),
  Phasesscreen(),
  Morescreen(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages[selectedPage];
        },
      ),
      bottomNavigationBar: const ImageLikeBottomNavBar(),
    );
  }
}