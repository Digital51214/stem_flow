import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Services/show_project_list.dart';
import 'package:stemflow/Services/team_list_service.dart';
import 'package:stemflow/Services/add_phase_service.dart';
import 'package:stemflow/Services/session_manager.dart';
import 'package:stemflow/models/project_model.dart';
import 'package:stemflow/models/teams_models.dart';
import 'package:stemflow/PhaseDetailScreen.dart';

class CreatePhaseScreen extends StatefulWidget {
  const CreatePhaseScreen({super.key});

  @override
  State<CreatePhaseScreen> createState() => _CreatePhaseScreenState();
}

class _CreatePhaseScreenState extends State<CreatePhaseScreen> {
  final TextEditingController phaseNameC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();

  bool isLoading = false;
  bool isSaving = false;

  List<ProjectModel> projects = [];
  List<MyTeamModel> teams = [];

  ProjectModel? selectedProject;
  MyTeamModel? selectedTeam;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    setState(() => isLoading = true);

    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      final projectResult = await ShowProjectService.getUserProjects(
        userId: userId,
        apiKey: "YOUR_API_KEY_HERE",
      );

      final teamResult = await MyTeamService.getMyTeams(
        userId: userId,
        apiKey: "YOUR_API_KEY_HERE",
      );

      setState(() {
        projects = projectResult;
        teams = teamResult;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> savePhase() async {
    if (phaseNameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phase name required")),
      );
      return;
    }

    if (selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select project")),
      );
      return;
    }

    if (selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select team")),
      );
      return;
    }

    if (descriptionC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Description required")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      final response = await AddPhaseService.addPhase(
        userId: userId,
        teamId: selectedTeam!.id,
        projectId: selectedProject!.id,
        phaseName: phaseNameC.text.trim(),
        phaseDescription: descriptionC.text.trim(),
        apiKey: "YOUR_API_KEY_HERE",
      );

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Phase created")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhaseDetailsScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Failed to create phase")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF287D80),
      body: Bg(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withOpacity(0.88),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.042),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mq.height * 0.025),
                    Row(
                      children: [
                        BackCircle(onTap: () => Navigator.pop(context)),
                        const Spacer(),
                        Image.asset(
                          "assets/images/Logo.png",
                          height: mq.height * 0.055,
                          width: mq.width * 0.12,
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.045),
                    Text(
                      "Phase Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.052,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: mq.height * 0.028),
                    if (isLoading)
                      SizedBox(
                        height: mq.height * 0.45,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF287D80),
                          ),
                        ),
                      )
                    else
                      _GlassCard(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            mq.width * 0.065,
                            mq.height * 0.035,
                            mq.width * 0.065,
                            mq.height * 0.035,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label("PHASE NAME"),
                              SizedBox(height: mq.height * 0.012),
                              _CustomTextField(
                                controller: phaseNameC,
                                hint: "e.g. Manufacturing",
                              ),
                              SizedBox(height: mq.height * 0.018),
                              const _Label("SELECT PROJECT"),
                              SizedBox(height: mq.height * 0.012),
                              _ProjectDropdown(
                                hint: "Select Project",
                                value: selectedProject,
                                items: projects,
                                onChanged: (value) {
                                  setState(() {
                                    selectedProject = value;
                                  });
                                },
                              ),
                              SizedBox(height: mq.height * 0.018),
                              const _Label("SELECT TEAM"),
                              SizedBox(height: mq.height * 0.012),
                              _TeamDropdown(
                                hint: "Select Team",
                                value: selectedTeam,
                                items: teams,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTeam = value;
                                  });
                                },
                              ),
                              SizedBox(height: mq.height * 0.018),
                              const _Label("DESCRIPTION"),
                              SizedBox(height: mq.height * 0.012),
                              _DescriptionField(
                                controller: descriptionC,
                                hint: "In this phase, the team focuses on\noptimizing how air flows...",
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: mq.height * 0.028),
                    SizedBox(
                      width: double.infinity,
                      height: mq.height * 0.058,
                      child: ElevatedButton(
                        onPressed: isSaving || isLoading ? null : savePhase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF287D80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        child: isSaving
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Save Phase",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mq.width * 0.034,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.06),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontFamily: "Mynor",
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF8CCDCF).withOpacity(0.52),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _CustomTextField({
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: "Mynor",
        ),
        decoration: InputDecoration(
          hint: Text(
            hint,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontFamily: "Mynor",
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _ProjectDropdown extends StatelessWidget {
  final String hint;
  final ProjectModel? value;
  final List<ProjectModel> items;
  final ValueChanged<ProjectModel?> onChanged;

  const _ProjectDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: DropdownButtonFormField<ProjectModel>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF287D80),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
        ),
        hint: Text(
          hint,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontFamily: "Mynor",
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: "Mynor",
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        items: items.map((project) {
          return DropdownMenuItem<ProjectModel>(
            value: project,
            child: Text(
              project.projectName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _TeamDropdown extends StatelessWidget {
  final String hint;
  final MyTeamModel? value;
  final List<MyTeamModel> items;
  final ValueChanged<MyTeamModel?> onChanged;

  const _TeamDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: DropdownButtonFormField<MyTeamModel>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF287D80),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
        ),
        hint: Text(
          hint,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontFamily: "Mynor",
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: "Mynor",
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
        items: items.map((team) {
          return DropdownMenuItem<MyTeamModel>(
            value: team,
            child: Text(
              team.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _DescriptionField({
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      maxLines: 4,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: "Mynor",
      ),
      decoration: InputDecoration(
        hint: Text(
          hint,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontFamily: "Mynor",
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}