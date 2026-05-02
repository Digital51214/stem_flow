import 'package:flutter/material.dart';

import 'package:stemflow/AiInsights.dart';
import 'package:stemflow/HomeScreen.dart';
import 'package:stemflow/MoreScreen.dart';
import 'package:stemflow/PhasesScreen.dart';
import 'package:stemflow/TasksScreen.dart';


import 'package:stemflow/team_management_screen/project_list_screen.dart';
import 'package:stemflow/team_side%20screens/events_meating_teamSide.dart';
import 'package:stemflow/team_side%20screens/profile_team_side.dart';
import 'package:stemflow/team_side%20screens/team_task.dart';

import 'AI_insights_team.dart';
import 'customBottomNav_teamSide.dart';
import 'home_task_screen.dart';


final List<Widget> pages = [
  HomeTask(),
  MyTasksScreen(),
  AiInsightsTeamSide(),
  EventsMeetingsScreen(),

 ProfileScreen(),
];

class WidgetTree2 extends StatelessWidget {
  const WidgetTree2({super.key});

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
      floatingActionButton: const CenterAiButton2(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const ImageLikeBottomNavBar2(),
    );
  }
}