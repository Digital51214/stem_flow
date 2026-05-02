import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stemflow/CreateTaskScreen.dart';
import 'package:stemflow/Widgets/background.dart';
import 'Services/get_task_service.dart';
import 'Services/team_list_service.dart';
import 'models/teams_models.dart';
import 'package:stemflow/Services/session_manager.dart';  // Added import for SessionManager

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // ── Teams ──
  bool _isLoadingTeams = false;
  List<MyTeamModel> _teams = [];
  MyTeamModel? _selectedTeam;

  // ── Tasks ──
  bool _isLoadingTasks = false;
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

  // ── Fetch Teams ──
  Future<void> _fetchTeams() async {
    setState(() => _isLoadingTeams = true);
    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      final result = await MyTeamService.getMyTeams(
        userId: userId,  // Now using dynamic userId
        apiKey: "YOUR_API_KEY_HERE",
      );
      if (!mounted) return;
      setState(() {
        _teams = result;
        // Auto-select first team and load its tasks
        if (result.isNotEmpty) {
          _selectedTeam = result.first;
          _fetchTasks(result.first.id);
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teams Error: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingTeams = false);
    }
  }

  // ── Fetch Tasks ──
  Future<void> _fetchTasks(int teamId) async {
    setState(() {
      _isLoadingTasks = true;
      _tasks = [];
    });
    try {
      final result = await GetTasksService.getTasks(teamId: teamId);
      if (!mounted) return;
      setState(() => _tasks = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tasks Error: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingTasks = false);
    }
  }

  // ── Priority helpers ──────────────────────────────────────────────────────

  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'HIGH PRIORITY';
      case 'medium':
        return 'MEDIUM PRIORITY';
      default:
        return 'LOW PRIORITY';
    }
  }

  Color _priorityTextColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return const Color(0xFFD06C00);
      default:
        return const Color(0xFF287D80);
    }
  }

  Color _priorityBgColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFF9C8C89);
      case 'medium':
        return const Color(0xFF9AA885);
      default:
        return const Color(0xFF7EC2C4);
    }
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'COMPLETED';
      case 'in_progress':
      case 'in progress':
        return 'IN PROGRESS';
      default:
        return 'TO DO';
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFF0059D8);
      default:
        return Colors.white;
    }
  }

  Color _statusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF287D80);
      case 'in_progress':
      case 'in progress':
        return const Color(0xFF0054D9);
      default:
        return const Color(0xFF4386BA);
    }
  }

  double _progressValue(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 1.0;
      case 'in_progress':
      case 'in progress':
        return 0.55;
      default:
        return 0.1;
    }
  }

  // ── Deadline formatter: "2026-03-15" → "Mar 15, 2026" ────────────────────

  String _formatDeadline(String deadline) {
    try {
      final parts = deadline.split('-');
      if (parts.length != 3) return deadline;
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      final year = parts[0];
      return '${months[month]} $day, $year';
    } catch (_) {
      return deadline;
    }
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.045),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: mq.height * 0.04),

                    // Logo
                    Container(
                      height: mq.height * 0.052,
                      width: mq.width * 0.11,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/Logo.png"),
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.03),

                    // ── Tasks title + Team Dropdown ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tasks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mq.width * 0.05,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        _isLoadingTeams
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : _teams.isEmpty
                            ? const SizedBox.shrink()
                            : _TeamDropdown(
                          mq: mq,
                          teams: _teams,
                          selectedTeam: _selectedTeam,
                          onChanged: (team) {
                            if (team == null) return;
                            setState(() => _selectedTeam = team);
                            _fetchTasks(team.id);
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: mq.height * 0.016),

                    // ── Loading / Empty / Task list ──
                    if (_isLoadingTasks)
                      _buildLoader(mq)
                    else if (_selectedTeam == null)
                      _buildSelectTeamState(mq)
                    else if (_tasks.isEmpty)
                        _buildEmptyState(mq)
                      else
                        ...List.generate(_tasks.length, (index) {
                          final task = _tasks[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: mq.height * 0.01),
                            child: _TaskCard(
                              priorityText: _priorityLabel(task.priority),
                              priorityColor: _priorityTextColor(task.priority),
                              priorityBg: _priorityBgColor(task.priority),
                              statusText: _statusLabel(task.status),
                              statusColor: _statusTextColor(task.status),
                              statusBg: _statusBgColor(task.status),
                              title: task.title,
                              date: _formatDeadline(task.deadline),
                              progress: _progressValue(task.status),
                            ),
                          );
                        }),

                    SizedBox(height: mq.height * 0.04),

                    // ── Create Task Button ──
                    _CreateTaskButton(
                      height: mq.height * 0.058,
                      onTap: _selectedTeam == null
                          ? null
                          : () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              projectId: 1,
                              teamId: _selectedTeam!.id,
                            ),
                          ),
                        );
                        _fetchTasks(_selectedTeam!.id);
                      },
                    ),

                    SizedBox(height: mq.height * 0.13),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoader(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF287D80),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildSelectTeamState(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: Center(
        child: Text(
          "Select a team to view tasks",
          style: TextStyle(
            color: Colors.white70,
            fontSize: mq.width * 0.038,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: Center(
        child: Text(
          "No tasks found",
          style: TextStyle(
            color: Colors.white70,
            fontSize: mq.width * 0.038,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Team Dropdown ────────────────────────────────────────────────────────────



  Widget _buildLoader(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF287D80),
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildSelectTeamState(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: Center(
        child: Text(
          "Select a team to view tasks",
          style: TextStyle(
            color: Colors.white70,
            fontSize: mq.width * 0.038,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size mq) {
    return SizedBox(
      height: mq.height * 0.2,
      child: Center(
        child: Text(
          "No tasks found",
          style: TextStyle(
            color: Colors.white70,
            fontSize: mq.width * 0.038,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


// ─── Team Dropdown ────────────────────────────────────────────────────────────

class _TeamDropdown extends StatelessWidget {
  final Size mq;
  final List<MyTeamModel> teams;
  final MyTeamModel? selectedTeam;
  final ValueChanged<MyTeamModel?> onChanged;

  const _TeamDropdown({
    required this.mq,
    required this.teams,
    required this.selectedTeam,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.042,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(mq.width * 0.07),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MyTeamModel>(
          value: selectedTeam,
          isDense: true,
          dropdownColor: const Color(0xFF3AACB0),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: mq.width * 0.05,
          ),
          hint: Text(
            "Select Team",
            style: TextStyle(
              color: Colors.white70,
              fontSize: mq.width * 0.031,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w500,
            ),
          ),
          selectedItemBuilder: (_) => teams.map((t) {
            return Center(
              child: Text(
                t.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.031,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
          items: teams.map((t) {
            return DropdownMenuItem<MyTeamModel>(
              value: t,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF287D80).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      t.icon.isNotEmpty ? t.icon : t.name[0].toUpperCase(),
                      style: TextStyle(fontSize: mq.width * 0.04),
                    ),
                  ),
                  SizedBox(width: mq.width * 0.025),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF287D80),
                            fontSize: mq.width * 0.034,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          t.year,
                          style: TextStyle(
                            color: const Color(0xFF287D80).withOpacity(0.65),
                            fontSize: mq.width * 0.026,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─── Task Card ────────────────────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final String priorityText;
  final Color priorityColor;
  final Color priorityBg;
  final String statusText;
  final Color statusColor;
  final Color statusBg;
  final String title;
  final String date;
  final double progress;

  const _TaskCard({
    required this.priorityText,
    required this.priorityColor,
    required this.priorityBg,
    required this.statusText,
    required this.statusColor,
    required this.statusBg,
    required this.title,
    required this.date,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return _GlassCard(
      height: mq.height * 0.17,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.085,
          vertical: mq.height * 0.014,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TaskChip(
                      text: priorityText,
                      textColor: priorityColor,
                      bgColor: priorityBg,
                      width: mq.width * 0.27,
                      height: mq.height * 0.027,
                    ),
                    SizedBox(width: mq.width * 0.015),
                    _TaskChip(
                      text: statusText,
                      textColor: statusColor,
                      bgColor: statusBg,
                      width: mq.width * 0.205,
                      height: mq.height * 0.027,
                    ),
                  ],
                ),
                SizedBox(height: mq.height * 0.016),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.034,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: mq.height * 0.01),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: mq.width * 0.028,
                    ),
                    SizedBox(width: mq.width * 0.008),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.028,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * 0.025),
                SizedBox(
                  width: mq.width * 0.295,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.width * 0.04),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: mq.height * 0.005,
                      backgroundColor: Colors.white.withOpacity(0.85),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF287D80),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: mq.width * 0.32,
              bottom: mq.height * -0.004,
              child: const Icon(
                Icons.more_vert,
                color: Color(0xFF287D80),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Task Chip ────────────────────────────────────────────────────────────────

class _TaskChip extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final double width;
  final double height;

  const _TaskChip({
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.82),
        borderRadius: BorderRadius.circular(mq.width * 0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: mq.width * 0.018,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Create Task Button ───────────────────────────────────────────────────────

class _CreateTaskButton extends StatelessWidget {
  final double height;
  final VoidCallback? onTap;

  const _CreateTaskButton({
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final bool enabled = onTap != null;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: enabled
            ? const Color(0xFF287D80)
            : const Color(0xFF287D80).withOpacity(0.45),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: mq.width * 0.06,
            ),
            SizedBox(width: mq.width * 0.015),
            Text(
              "Create Task",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.038,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final double height;
  final Widget child;

  const _GlassCard({
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}