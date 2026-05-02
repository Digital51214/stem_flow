import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/Services/session_manager.dart';  // Added import for SessionManager
import '../Services/create_project_service.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    projectNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF287D80),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> saveProject() async {
    final projectName = projectNameController.text.trim();
    final description = descriptionController.text.trim();

    if (projectName.isEmpty) {
      showToast("Please enter project name");
      return;
    }

    if (description.isEmpty) {
      showToast("Please enter project description");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      print("Save Project Button Pressed");
      print("Project Name: $projectName");
      print("Description: $description");

      final result = await ProjectService.createProject(
        userId: userId,  // Now using dynamic userId
        projectName: projectName,
        description: description,
      );

      print("Project Created Successfully: $result");

      showToast(result["message"] ?? "Project created successfully");

      projectNameController.clear();
      descriptionController.clear();
    } catch (e) {
      print("Save Project Error: $e");
      showToast("Failed to create project");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

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

                const SizedBox(height: 32),

                const Text(
                  "Create Project",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Mynor",
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Create your project and description",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Mynor",
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6FC7C8).withOpacity(0.45),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PROJECT NAME",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontFamily: "Mynor",
                        ),
                      ),

                      const SizedBox(height: 12),

                      ProjectTextField(
                        controller: projectNameController,
                        hintText: "e.g. Aerodynamics Lead",
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        "PROJECT DESCRIPTION",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          fontFamily: "Mynor",
                        ),
                      ),

                      const SizedBox(height: 12),

                      ProjectTextField(
                        controller: descriptionController,
                        hintText:
                        "In this project, the team focuses on\noptimizing how air flows around the\ncar to reduce drag and increase\nspeed. The design of the car's body,\nwings, and surfaces is carefully tested\nand refined.",
                        maxLines: 7,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF287D80),
                      disabledBackgroundColor: const Color(0xFF287D80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Save Project",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Mynor",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const ProjectTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: "Mynor",
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.75),
          fontSize: 11,
          height: 1.25,
          fontWeight: FontWeight.w500,
          fontFamily: "Mynor",
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}