import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/BudgetScreen.dart';
import 'package:stemflow/NotificationScreen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/team_management_screen/your_team_list.dart';
import 'Services/show_project_list.dart';
import 'Services/show_phase_service.dart';
import 'models/project_model.dart';
import 'models/phase_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoadingProjects = false;
  bool _isLoadingPhases = false;

  List<ProjectModel> _projects = [];
  ProjectModel? _selectedProject;

  List<PhaseModel> _phases = [];
  PhaseModel? _selectedPhase;

  final int _userId = 1;
  final String _apiKey = "YOUR_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    setState(() => _isLoadingProjects = true);
    try {
      final result = await ShowProjectService.getUserProjects(
        userId: _userId,
        apiKey: _apiKey,
      );
      if (!mounted) return;
      setState(() {
        _projects = result;
        if (_projects.isNotEmpty) _selectedProject = _projects.first;
      });
      if (_projects.isNotEmpty) {
        await _fetchPhases(_projects.first.id);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingProjects = false);
    }
  }

  Future<void> _fetchPhases(int projectId) async {
    setState(() {
      _isLoadingPhases = true;
      _phases = [];
      _selectedPhase = null;
    });
    try {
      final result = await ShowPhaseService.getProjectPhases(
        userId: _userId,
        projectId: projectId,
        apiKey: _apiKey,
      );
      if (!mounted) return;
      setState(() {
        _phases = result;
        // Default: first active phase, fallback to first
        _selectedPhase = result.firstWhere(
              (p) => p.isActive,
          orElse: () => result.isNotEmpty ? result.first : _selectedPhase!,
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingPhases = false);
    }
  }

  Widget _buildInlineLoader(String label) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          const SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontFamily: "Mynor",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
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
                      Colors.white.withOpacity(0.85),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: mq.height * 0.035),

                      // ── Top Bar ──
                      Row(
                        children: [
                          Container(
                            height: 44,
                            width: 45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/Logo.png"),
                              ),
                            ),
                          ),
                          const Spacer(),
                          _RoundIconButton(
                            icon: Icons.notifications,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => NotificationsScreen()),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── Current Phase Card ──
                      _GlassCard(
                        height: 210,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Header: label + active badge
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Current Phase",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.75),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      _selectedPhase?.isActive == true
                                          ? "Active Now"
                                          : "Inactive",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              // ── Project Dropdown ──
                              if (_isLoadingProjects)
                                _buildInlineLoader("Loading projects...")
                              else if (_projects.isEmpty)
                                const Text(
                                  "No projects found",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              else
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<ProjectModel>(
                                    value: _selectedProject,
                                    isDense: true,
                                    dropdownColor: const Color(0xFF287D80),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    selectedItemBuilder: (_) => _projects
                                        .map((p) => Text(
                                      p.projectName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ))
                                        .toList(),
                                    items: _projects
                                        .map((p) => DropdownMenuItem<ProjectModel>(
                                      value: p,
                                      child: Text(
                                        p.projectName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Mynor",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (ProjectModel? value) {
                                      if (value != null) {
                                        setState(() => _selectedProject = value);
                                        _fetchPhases(value.id);
                                      }
                                    },
                                  ),
                                ),

                              const SizedBox(height: 6),

                              // ── Phase Dropdown ──
                              if (_isLoadingPhases)
                                _buildInlineLoader("Loading phases...")
                              else if (_phases.isEmpty)
                                Text(
                                  "No phases found",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              else
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<PhaseModel>(
                                    value: _selectedPhase,
                                    isDense: true,
                                    dropdownColor: const Color(0xFF287D80),
                                    hint: const Text(
                                      "Select Phase",
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    // What shows when dropdown is closed
                                    selectedItemBuilder: (_) => _phases
                                        .map((ph) => Row(
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          margin: const EdgeInsets.only(right: 7),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ph.isActive
                                                ? const Color(0xff4EB7BD)
                                                : Colors.white38,
                                          ),
                                        ),
                                        Text(
                                          ph.phaseName,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.85),
                                            fontSize: 13,
                                            fontFamily: "Mynor",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ))
                                        .toList(),
                                    // What shows in the open dropdown list
                                    items: _phases
                                        .map((ph) => DropdownMenuItem<PhaseModel>(
                                      value: ph,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 7,
                                            height: 7,
                                            margin: const EdgeInsets.only(
                                                right: 8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ph.isActive
                                                  ? const Color(0xff4EB7BD)
                                                  : Colors.white38,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ph.phaseName,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: "Mynor",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${ph.progressPercentage.toInt()}%",
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.65),
                                              fontSize: 11,
                                              fontFamily: "Mynor",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                        .toList(),
                                    onChanged: (PhaseModel? value) {
                                      if (value != null) {
                                        setState(() => _selectedPhase = value);
                                      }
                                    },
                                  ),
                                ),

                              const SizedBox(height: 20),


                              // ── Progress Row ──
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Overall Progress",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.85),
                                        fontSize: 10,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _selectedPhase != null
                                        ? "${_selectedPhase!.progressPercentage.toInt()}%"
                                        : "—",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 10,
                                      fontFamily: "Mynor",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: _selectedPhase != null
                                      ? _selectedPhase!.progressPercentage / 100
                                      : 0.0,
                                  minHeight: 8,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xff4EB7BD).withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── 3 Stats Cards ──
                      Row(
                        children: [
                          Expanded(
                            child: _SmallStatCard(
                              icon: Icons.format_list_bulleted_rounded,
                              value: _phases.isNotEmpty ? "${_phases.length}" : "—",
                              label: "Phases",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SmallStatCard(
                              icon: Icons.timer_outlined,
                              value: "2",
                              label: "Deadlines",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SmallStatCard(
                              icon: Icons.trending_up_rounded,
                              value: _selectedPhase != null
                                  ? "${_selectedPhase!.progressPercentage.toInt()}%"
                                  : "—",
                              label: "Success",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Budget Overview Card ──
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BudgetScreen())),
                        child: _GlassCard(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 13, left: 15, right: 15, bottom: 9),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.attach_money_rounded,
                                          color: Colors.white, size: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Budget Overview",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontFamily: "Mynor",
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BudgetScreen())),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add,
                                              size: 18, color: Color(0xff287D80)),
                                          Text(
                                            "Add Expence",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: const Color(0xff287D80),
                                              decoration: TextDecoration.underline,
                                              decorationColor:
                                              const Color(0xff287D80),
                                              decorationThickness: 2,
                                              fontFamily: "Mynor",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 88,
                                      height: 88,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircularProgressIndicator(
                                              value: 0.3,
                                              strokeWidth: 5,
                                              backgroundColor:
                                              Colors.white.withOpacity(0.22),
                                              valueColor:
                                              const AlwaysStoppedAnimation<Color>(
                                                  Color(0xff287D80)),
                                            ),
                                          ),
                                          Container(
                                            width: 67,
                                            height: 67,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "420\$",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: "Mynor",
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      children: [
                                        _LegendRow(
                                            dotColor: const Color(0xff287D80),
                                            text: "Materials: 210"),
                                        const SizedBox(height: 10),
                                        _LegendRow(
                                            dotColor: Colors.white,
                                            text: "Remaining"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: mq.height * 0.015),

                      // ── Your Team Button ──
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const YourTeamsScreen())),
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.8), width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: const [
                                Text(
                                  "Your Team",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_outlined,
                                    color: Colors.white, size: 15),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: mq.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final double height;
  final Widget child;
  const _GlassCard({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _SmallStatCard(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return _GlassCard(
      height: mq.height * 0.125,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            SizedBox(height: mq.height * 0.01),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 1),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Mynor")),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color dotColor;
  final String text;
  const _LegendRow({required this.dotColor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(text,
            style: TextStyle(
                color: Colors.white.withOpacity(0.90),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: "Mynor")),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Icon(icon, color: const Color(0xFF287D80), size: 22),
      ),
    );
  }
}