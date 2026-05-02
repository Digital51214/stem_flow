import 'package:flutter/material.dart';
import 'package:stemflow/AiInsights.dart';
import 'package:stemflow/HomeScreen.dart';
import 'package:stemflow/MoreScreen.dart';
import 'package:stemflow/PhasesScreen.dart';
import 'package:stemflow/TasksScreen.dart';
import 'package:stemflow/Widgets/CustomBottomNavBar.dart';
import 'package:stemflow/team_management_screen/project_list_screen.dart';

final List<Widget> pages = [
  HomeScreen(),
  TaskScreen(),
  Phasesscreen(),
  ProjectListScreen(),

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
      floatingActionButton: const CenterAiButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const ImageLikeBottomNavBar(),
    );
  }
}