import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/BigButton.dart';
import 'package:stemflow/Widgets/PillSmall.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/progless_line.dart';
import 'package:stemflow/team_management_screen/createteam_screen.dart';
import 'package:stemflow/team_management_screen/jointeam_screen.dart';

import '../Widgets/CustomBottomNavBar.dart';

class TeamStep1Screen extends StatefulWidget {
  const TeamStep1Screen({super.key});

  @override
  State<TeamStep1Screen> createState() => _TeamStep1ScreenState();
}

class _TeamStep1ScreenState extends State<TeamStep1Screen> {
  bool isCreateSelected = true; // default selected

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mq.height * 0.035),

                // Back button
                Row(children: [BackCircle(onTap: () => Navigator.pop(context)),
                  Spacer(),
                  Container(
                    height: 44,
                    width: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/Logo.png")),
                    ),
                  )
                ]),

                const SizedBox(height: 16),

                // Step + progress
                const Text(
                  "Step 1 of 2",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Mynor",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ProgressLine(active: true),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ProgressLine(active: false),
                    ),
                  ],
                ),

                SizedBox(height: mq.height * 0.12),

                // Center icon image (team)
                Center(
                  child: Image.asset(
                    "assets/images/helemet_image.png", // <-- add your image
                    height: mq.height * 0.3,
                    width: mq.width*0.8,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: mq.height * 0.09),

                // Pills row
                Row(
                  children: [
                    Expanded(
                      child: PillSmall(
                        text: "Create Team",
                        icon: Icons.edit,
                        selected: isCreateSelected,
                        onTap: () => setState(() => isCreateSelected = true),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: PillSmall(
                        text: "Join Team",
                        icon: Icons.add,
                        selected: !isCreateSelected,
                        onTap: () => setState(() => isCreateSelected = false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Next button
                BigButton(
                  text: "Next",
                  onTap: () {
                    if (isCreateSelected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateTeamScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JoinTeamScreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have a team. ",
                      style: TextStyle(
                        color: Color(0xFF287D80),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Mynor",
                      ),
                      ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WidgetTree(),
                      ),
                    );
                  },
                  child: const Text("Skip this step -->",
                    style: TextStyle(
                   decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      decorationThickness: 2,
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Mynor",
                    ),),
                ), ],
                ),
                const Spacer(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}