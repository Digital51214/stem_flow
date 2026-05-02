import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/BigButton.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Widgets/progless_line.dart';
import 'package:stemflow/Widgets/roundedfield.dart';
import 'package:stemflow/services/join_team_service.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({super.key});

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final TextEditingController codeC = TextEditingController();

  bool isLoading = false;

  final Color themeColor = const Color(0xFF287D80);

  @override
  void dispose() {
    codeC.dispose();
    super.dispose();
  }

  void showToast(String message) {
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
        backgroundColor: themeColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> joinTeam() async {
    if (isLoading) return;

    if (codeC.text.trim().isEmpty) {
      showToast("Please enter invite code");
      return;
    }

    setState(() => isLoading = true);
    print("Join Team Loader Started");

    try {
      final result = await JoinTeamService.joinTeam(
        userId: 6,
        inviteCode: codeC.text.trim(),
      );

      print("Join Team Final Result: $result");

      if (!mounted) return;

      if (result["status"] == 200 || result["status"] == 201) {
        showToast(result["message"] ?? "Joined successfully!");
      } else {
        showToast(result["message"] ?? "Failed to join team");
      }
    } catch (e) {
      print("Join Team Error: $e");

      if (!mounted) return;
      showToast("Something went wrong. Please try again.");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
        print("Join Team Loader Stopped");
      }
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

                      const Row(
                        children: [
                          Expanded(child: ProgressLine(active: true)),
                          SizedBox(width: 18),
                          Expanded(child: ProgressLine(active: true)),
                        ],
                      ),

                      SizedBox(height: mq.height * 0.06),

                      Center(
                        child: Image.asset(
                          "assets/images/jointeam_image.png",
                          height: 214,
                          width: 211,
                        ),
                      ),

                      SizedBox(height: mq.height * 0.036),

                      const Text(
                        "Join Team",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Mynor",
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Enter Invite Code to join Team!",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Mynor",
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: mq.height * 0.03),

                      RoundedField(
                        hint: "Enter Code...",
                        controller: codeC,
                      ),

                      SizedBox(height: mq.height * 0.033),

                      Opacity(
                        opacity: isLoading ? 0.6 : 1,
                        child: BigButton(
                          text: isLoading ? "Please wait..." : "Join Team",
                          onTap: () {
                            if (isLoading) return;
                            joinTeam();
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