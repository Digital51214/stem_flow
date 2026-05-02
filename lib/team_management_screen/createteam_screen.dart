import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Services/team_service.dart';
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

  bool isLoading = false;

  // Apne BigButton wala exact color yahan set kar dena
  final Color buttonColor = const Color(0xFF287D80);

  @override
  void dispose() {
    teamNameC.dispose();
    descC.dispose();
    super.dispose();
  }

  void showToastMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: buttonColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> createTeamApi() async {
    if (isLoading) return;

    if (teamNameC.text.trim().isEmpty) {
      showToastMessage("Please enter team name");
      return;
    }

    if (descC.text.trim().isEmpty) {
      showToastMessage("Please enter description");
      return;
    }

    if (selectedIcon == null) {
      showToastMessage("Please select team icon");
      return;
    }

    setState(() => isLoading = true);
    print("Create Team Loader Started");

    final result = await TeamService.createTeam(
      userId: 1,
      teamName: teamNameC.text.trim(),
      year: sessionYear,
      description: descC.text.trim(),

      // Temporary IconData value
      iconBase64: "data:image/png;base64,${selectedIcon!.codePoint}",
    );

    print("Create Team Loader Stopped");
    print("Create Team Final Result: $result");

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result["success"] == true) {
      print("Team Created Successfully");
      print("Invite Code: ${result["data"]["invite_code"]}");

      showToastMessage(result["message"] ?? "Team Created Successfully!");

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WidgetTree(),
          ),
        );
      });
    } else {
      print("Create Team Failed: ${result["message"]}");
      showToastMessage(result["message"] ?? "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mq.height * 0.035),

                      Row(
                        children: [
                          BackCircle(
                            onTap: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Container(
                            height: 44,
                            width: 45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/Logo.png"),
                              ),
                            ),
                          ),
                        ],
                      ),

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

                            print("Selected Icon CodePoint: ${icon.codePoint}");
                          }
                        },
                      ),

                      SizedBox(height: mq.height * 0.078),

                      Opacity(
                        opacity: isLoading ? 0.6 : 1,
                        child: BigButton(
                          text: "Create Team",
                          onTap: () {
                            if (isLoading) return;
                            createTeamApi();
                          },
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),

              if (isLoading)
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.35),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}