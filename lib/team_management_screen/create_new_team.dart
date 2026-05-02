import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/IconPickerDialog.dart';
import '../Widgets/background.dart';
import '../services/team_service.dart'; // <-- apna service path

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController teamNameC = TextEditingController();
  final TextEditingController yearC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();

  IconData? selectedIcon;

  bool isLoading = false;

  /// ================= API CALL =================
  Future<void> createTeam() async {
    if (teamNameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team name required")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      print("Creating team from UI...");

      final response = await TeamService.createTeam(
        userId: 1,
        teamName: teamNameC.text.trim(),
        year: yearC.text.trim().isEmpty ? "2026" : yearC.text.trim(),
        description: descriptionC.text.trim().isEmpty
            ? "Default description"
            : descriptionC.text.trim(),
        iconBase64: selectedIcon != null
            ? selectedIcon!.codePoint.toString()
            : "",
      );

      print("UI Response: $response");

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"])),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DummyNextScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"])),
        );
      }
    } catch (e) {
      print("UI Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.018),

                  /// TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF287D80),
                            size: 18,
                          ),
                        ),
                      ),
                      Image.asset(
                        "assets/images/Logo.png",
                        height: 47,
                        width: 47,
                      ),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.045),

                  const Text(
                    "Create Team",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Initialize your high-performance engineering unit.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: mq.height * 0.035),

                  /// FORM CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(26, 34, 26, 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8CCDCF).withOpacity(0.23),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TEAM NAME
                        const Text(
                          "TEAM NAME",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),

                        TextField(
                          controller: teamNameC,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration("e.g. Aerodynamics Lead"),
                        ),

                        const SizedBox(height: 18),

                        /// YEAR
                        const Text(
                          "YEAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),

                        TextField(
                          controller: yearC,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration("e.g. 2026"),
                        ),

                        const SizedBox(height: 18),

                        /// DESCRIPTION
                        const Text(
                          "DESCRIPTION",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),

                        TextField(
                          controller: descriptionC,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.white),
                          decoration:
                          _inputDecoration("Short team description"),
                        ),

                        const SizedBox(height: 18),

                        /// ICON PICKER
                        const Text(
                          "TEAM ICON",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),

                        GestureDetector(
                          onTap: () async {
                            final icon = await showDialog<IconData>(
                              context: context,
                              builder: (_) => const IconPickerDialog(),
                            );

                            if (icon != null) {
                              setState(() => selectedIcon = icon);
                            }
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  selectedIcon == null
                                      ? "Upload Team Icon"
                                      : "Icon Selected",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                ),
                                const Spacer(),
                                Icon(
                                  selectedIcon ?? Icons.upload_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : createTeam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287D80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Create Team",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              )),
                          SizedBox(width: 8),
                          Icon(Icons.rocket_launch_outlined,
                              size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.white),
      ),
    );
  }
}

/// Dummy Next Screen
class DummyNextScreen extends StatelessWidget {
  const DummyNextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF287D80),
      body: Center(
        child: Text(
          "Team Created Successfully 🚀",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}