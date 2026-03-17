import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/BigButton.dart';
import 'package:stemflow/Widgets/IconPickerDialog.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/dropdownfield.dart';
import 'package:stemflow/Widgets/progless_line.dart';
import 'package:stemflow/Widgets/roundedfield.dart';
import 'package:stemflow/Widgets/uploadfield.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController teamNameC = TextEditingController();
  final TextEditingController descC = TextEditingController();

  String sessionYear = "2024 / 2025";
  IconData? selectedIcon;

  @override
  void dispose() {
    teamNameC.dispose();
    descC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.035),

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
                      Expanded(child: ProgressLine(active: true)),
                      const SizedBox(width: 18),
                      Expanded(child: ProgressLine(active: true)),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.025),

                  const Text(
                    "Create Team",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Mynor",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Enter Team Details to create a Team!",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Mynor",
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),

                  RoundedField(
                    hint: "Team Name...",
                    controller: teamNameC,
                  ),
                  const SizedBox(height: 5),

                  DropdownField(
                    value: sessionYear,
                    items: const [
                      "2020 / 2021",
                      "2021 / 2022",
                      "2022 / 2023",
                      "2023 / 2024",
                      "2024 / 2025",
                      "2025 / 2026",
                      "2026 / 2027",
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => sessionYear = val);
                      }
                    },
                  ),
                  const SizedBox(height: 5),

                  RoundedField(
                    hint: "Description...",
                    controller: descC,
                    maxLines: 4,
                    height: 118,
                  ),

                  const SizedBox(height: 5),

                  // ✅ Updated UploadField with selectedIcon passed
                  UploadField(
                    text: "Team Icon Upload",
                    isSelected: selectedIcon != null,
                    selectedIcon: selectedIcon,
                    onTap: () async {
                      final icon = await showDialog<IconData>(
                        context: context,
                        builder: (_) => const IconPickerDialog(),
                      );
                      if (icon != null) {
                        setState(() {
                          selectedIcon = icon;
                        });
                      }
                    },
                  ),

                  SizedBox(height: mq.height * 0.078),

                  BigButton(
                    text: "Create Team",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WidgetTree(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}