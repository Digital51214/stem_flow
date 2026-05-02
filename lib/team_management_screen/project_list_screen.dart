import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/background.dart';

import '../models/project_model.dart';
import '../Services/show_project_list.dart';
import 'create_project_screen.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  bool isLoading = false;
  List<ProjectModel> projects = [];

  final int userId = 1;
  final String apiKey = 'YOUR_API_KEY_HERE';

  @override
  void initState() {
    super.initState();
    fetchProjects();
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

  Future<void> fetchProjects() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      print('Fetching projects...');

      final result = await ShowProjectService.getUserProjects(
        userId: userId,
        apiKey: apiKey,
      );

      print('Projects loaded successfully');
      print('Total Projects: ${result.length}');

      if (!mounted) return;

      setState(() {
        projects = result;
      });
    } catch (e) {
      print('Fetch Projects Error: $e');

      if (mounted) {
        showToast('Failed to load projects');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> openCreateProjectScreen() async {
    final isCreated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateProjectScreen(),
      ),
    );

    print('Create Project Screen Result: $isCreated');

    if (isCreated == true) {
      print('Refreshing project list...');
      fetchProjects();
    }
  }

  Future<void> refreshProjects() async {
    print('Pull to refresh projects...');
    await fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                Row(
                  children: [
                    Image.asset(
                      "assets/images/Logo.png",
                      height: 47,
                      width: 47,
                    ),
                    const Spacer(),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF287D80),
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF287D80),
                    ),
                  )
                      : RefreshIndicator(
                    color: const Color(0xFF287D80),
                    onRefresh: refreshProjects,
                    child: projects.isEmpty
                        ? ListView(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 220),
                        Center(
                          child: Text(
                            'No projects found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Mynor",
                            ),
                          ),
                        ),
                      ],
                    )
                        : ListView.separated(
                      physics:
                      const AlwaysScrollableScrollPhysics(),
                      itemCount: projects.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        return ProjectCard(
                          project: projects[index],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: openCreateProjectScreen,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 22,
                    ),
                    label: const Text(
                      "Create Project",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Mynor",
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF287D80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6FC7C8).withOpacity(0.55),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
            width: 80,
            child: PhaseBadge(),
          ),
          const SizedBox(height: 12),
          Text(
            project.projectName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: "Mynor",
            ),
          ),
          const SizedBox(height: 6),
          Text(
            project.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              height: 1.3,
              fontWeight: FontWeight.w500,
              fontFamily: "Mynor",
            ),
          ),
        ],
      ),
    );
  }
}

class PhaseBadge extends StatelessWidget {
  const PhaseBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
      ),
      child: const Text(
        "ACTIVE PHASE",
        style: TextStyle(
          color: Color(0xFF287D80),
          fontSize: 6,
          fontWeight: FontWeight.w900,
          fontFamily: "Mynor",
        ),
      ),
    );
  }
}