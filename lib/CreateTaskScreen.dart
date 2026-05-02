import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/TaskDetailScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/team_side%20screens/BottomNavigation_screen_teamSide.dart';
import 'Services/add_task_service.dart';
import 'Services/show_phase_service.dart';
import 'Services/team_details_service.dart';
import 'models/phase_model.dart';
import 'models/member_model.dart';

class CreateTaskScreen extends StatefulWidget {
  final int projectId;
  final int teamId;

  const CreateTaskScreen({
    super.key,
    required this.projectId,
    required this.teamId,
  });

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  // ── Controllers ──
  final TextEditingController _titleController = TextEditingController();

  // ── Loading states ──
  bool _isLoadingPhases = false;
  bool _isLoadingMembers = false;
  bool _isCreatingTask = false;

  // ── Data ──
  List<PhaseModel> _phases = [];
  PhaseModel? _selectedPhase;

  List<MemberModel> _members = [];
  MemberModel? _selectedMember;

  // ── Other fields ──
  String selectedPriority = "LOW";
  DateTime? selectedDate;

  final int _userId = 1;
  final String _apiKey = "YOUR_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    _fetchPhases();
    _fetchMembers();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // ── Fetch Phases ──
  Future<void> _fetchPhases() async {
    setState(() => _isLoadingPhases = true);
    try {
      final result = await ShowPhaseService.getProjectPhases(
        userId: _userId,
        projectId: widget.projectId,
        apiKey: _apiKey,
      );
      if (!mounted) return;
      setState(() => _phases = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phases: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingPhases = false);
    }
  }

  // ── Fetch Members ──
  Future<void> _fetchMembers() async {
    setState(() => _isLoadingMembers = true);
    try {
      final result = await GetTeamMembersService.getMembers(
        teamId: widget.teamId,
      );
      if (!mounted) return;
      setState(() => _members = result);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Members: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoadingMembers = false);
    }
  }

  // ── Create Task ──
  Future<void> _createTask() async {
    // ── Validation ──
    final String title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    if (_selectedPhase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a phase')),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
      return;
    }

    setState(() => _isCreatingTask = true);

    try {
      final String deadline =
          "${selectedDate!.year.toString().padLeft(4, '0')}-"
          "${selectedDate!.month.toString().padLeft(2, '0')}-"
          "${selectedDate!.day.toString().padLeft(2, '0')}";

      final Map<String, dynamic> createdTask = await AddTaskService.addTask(
        userId: _userId,
        teamId: widget.teamId,
        phaseId: _selectedPhase!.id,
        title: title,
        priority: selectedPriority,
        deadline: deadline,
      );

      if (!mounted) return;

      print('[CreateTaskScreen] Task created: $createdTask');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task created successfully!'),
          backgroundColor: Color(0xFF287D80),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskDetailScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isCreatingTask = false);
    }
  }

  String get formattedDate {
    if (selectedDate == null) return "mm/dd/yy";
    return "${selectedDate!.month.toString().padLeft(2, '0')}/"
        "${selectedDate!.day.toString().padLeft(2, '0')}/"
        "${selectedDate!.year.toString().substring(2)}";
  }

  Future<void> pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF287D80),
              onPrimary: Colors.white,
              onSurface: Color(0xFF287D80),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
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
                    SizedBox(height: mq.height * 0.035),

                    // ── Top Bar ──
                    Row(
                      children: [
                        BackCircle(onTap: () => Navigator.pop(context)),
                        const Spacer(),
                        Container(
                          height: mq.height * 0.052,
                          width: mq.width * 0.11,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Logo.png"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: mq.height * 0.03),

                    Text(
                      "New Task",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.014),

                    _GlassCard(
                      height: mq.height * 0.76,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.075,
                          vertical: mq.height * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ── Task Title ──
                            _FieldLabel(text: "TASK TITLE", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _InputBox(
                              mq: mq,
                              hintText: "e.g. Aerodynamics Lead",
                              controller: _titleController,
                            ),

                            SizedBox(height: mq.height * 0.026),

                            // ── Phase Dropdown ──
                            _FieldLabel(text: "PHASE", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _isLoadingPhases
                                ? _LoadingBox(mq: mq, label: "Loading phases...")
                                : _phases.isEmpty
                                ? _EmptyBox(mq: mq, label: "No phases found")
                                : _PhaseDropdownBox(
                              mq: mq,
                              value: _selectedPhase,
                              phases: _phases,
                              onChanged: (val) =>
                                  setState(() => _selectedPhase = val),
                            ),

                            SizedBox(height: mq.height * 0.026),

                            // ── Assigned To Dropdown ──
                            _FieldLabel(text: "ASSIGNED TO", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _isLoadingMembers
                                ? _LoadingBox(mq: mq, label: "Loading members...")
                                : _members.isEmpty
                                ? _EmptyBox(mq: mq, label: "No members found")
                                : _MemberDropdownBox(
                              mq: mq,
                              value: _selectedMember,
                              members: _members,
                              onChanged: (val) =>
                                  setState(() => _selectedMember = val),
                            ),

                            SizedBox(height: mq.height * 0.026),

                            // ── Priority ──
                            _FieldLabel(text: "PRIORITY", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _PrioritySelector(
                              selectedPriority: selectedPriority,
                              onSelect: (value) =>
                                  setState(() => selectedPriority = value),
                            ),

                            SizedBox(height: mq.height * 0.026),

                            // ── Due Date ──
                            _FieldLabel(text: "DUE DATE", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _DateBox(
                              mq: mq,
                              dateText: formattedDate,
                              onTap: pickDueDate,
                            ),

                            SizedBox(height: mq.height * 0.026),

                            // ── Initial Status ──
                            _FieldLabel(text: "INITIAL STATUS", mq: mq),
                            SizedBox(height: mq.height * 0.016),
                            _StatusBox(mq: mq),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.028),

                    _CreateTaskButton(
                      height: mq.height * 0.056,
                      isLoading: _isCreatingTask,
                      onTap: _isCreatingTask ? null : _createTask,
                    ),

                    SizedBox(height: mq.height * 0.028),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WidgetTree2()),
                        );
                      },
                      child: Center(
                        child: Text(
                          "View Tasks",
                          style: TextStyle(
                            color: const Color(0xFF287D80),
                            fontSize: mq.width * 0.036,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.08),
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

// ─── Phase Dropdown ───────────────────────────────────────────────────────────

class _PhaseDropdownBox extends StatelessWidget {
  final Size mq;
  final PhaseModel? value;
  final List<PhaseModel> phases;
  final ValueChanged<PhaseModel?> onChanged;

  const _PhaseDropdownBox({
    required this.mq,
    required this.value,
    required this.phases,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PhaseModel>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF8CCDCF),
          hint: Text(
            "Select Phase",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: mq.width * 0.035,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w400,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: mq.width * 0.062,
          ),
          selectedItemBuilder: (_) => phases.map((ph) {
            return Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ph.isActive
                        ? const Color(0xFF287D80)
                        : Colors.white54,
                  ),
                ),
                Expanded(
                  child: Text(
                    ph.phaseName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.035,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
          items: phases.map((ph) {
            return DropdownMenuItem<PhaseModel>(
              value: ph,
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ph.isActive
                          ? const Color(0xFF287D80)
                          : Colors.white54,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ph.phaseName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF287D80),
                        fontSize: mq.width * 0.034,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    "${ph.progressPercentage.toInt()}%",
                    style: TextStyle(
                      color: const Color(0xFF287D80).withOpacity(0.65),
                      fontSize: mq.width * 0.028,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
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

// ─── Member Dropdown ──────────────────────────────────────────────────────────

class _MemberDropdownBox extends StatelessWidget {
  final Size mq;
  final MemberModel? value;
  final List<MemberModel> members;
  final ValueChanged<MemberModel?> onChanged;

  const _MemberDropdownBox({
    required this.mq,
    required this.value,
    required this.members,
    required this.onChanged,
  });

  Widget _avatar(MemberModel m, double radius) {
    if (m.profilePicUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(m.profilePicUrl!),
        onBackgroundImageError: (_, __) {},
        backgroundColor: const Color(0xFF287D80),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF287D80),
      child: Text(
        m.username.isNotEmpty ? m.username[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.9,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MemberModel>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF8CCDCF),
          hint: Text(
            "Select Member",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: mq.width * 0.035,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w400,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: mq.width * 0.062,
          ),
          selectedItemBuilder: (_) => members.map((m) {
            return Row(
              children: [
                _avatar(m, mq.width * 0.04),
                SizedBox(width: mq.width * 0.025),
                Expanded(
                  child: Text(
                    m.username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.035,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
          items: members.map((m) {
            return DropdownMenuItem<MemberModel>(
              value: m,
              child: Row(
                children: [
                  _avatar(m, mq.width * 0.038),
                  SizedBox(width: mq.width * 0.025),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          m.username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF287D80),
                            fontSize: mq.width * 0.034,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          m.role,
                          style: TextStyle(
                            color: const Color(0xFF287D80).withOpacity(0.65),
                            fontSize: mq.width * 0.027,
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

// ─── Loading / Empty Box ──────────────────────────────────────────────────────

class _LoadingBox extends StatelessWidget {
  final Size mq;
  final String label;
  const _LoadingBox({required this.mq, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          ),
          SizedBox(width: mq.width * 0.03),
          Text(
            label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: mq.width * 0.032,
              fontFamily: "Mynor",
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final Size mq;
  final String label;
  const _EmptyBox({required this.mq, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white54,
          fontSize: mq.width * 0.032,
          fontFamily: "Mynor",
        ),
      ),
    );
  }
}

// ─── Existing Widgets ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final Size mq;
  const _FieldLabel({required this.text, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: mq.width * 0.028,
        fontFamily: "Mynor",
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final Size mq;
  final String hintText;
  final TextEditingController controller;

  const _InputBox({
    required this.mq,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.055,
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: mq.width * 0.035,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.92),
            fontSize: mq.width * 0.035,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.055,
            vertical: mq.height * 0.015,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide:
            BorderSide(color: Colors.white.withOpacity(0.65), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: const BorderSide(color: Colors.white, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onSelect;
  const _PrioritySelector(
      {required this.selectedPriority, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.01),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      ),
      child: Row(
        children: [
          _PriorityChip(
              text: "LOW",
              selectedPriority: selectedPriority,
              onSelect: onSelect),
          _PriorityChip(
              text: "MEDIUM",
              selectedPriority: selectedPriority,
              onSelect: onSelect),
          _PriorityChip(
              text: "HIGH",
              selectedPriority: selectedPriority,
              onSelect: onSelect),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String text;
  final String selectedPriority;
  final ValueChanged<String> onSelect;
  const _PriorityChip(
      {required this.text,
        required this.selectedPriority,
        required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isSelected = selectedPriority == text;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(text),
        child: Container(
          height: mq.height * 0.037,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(mq.width * 0.07),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF287D80) : Colors.white,
              fontSize: mq.width * 0.029,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final Size mq;
  final String dateText;
  final VoidCallback onTap;
  const _DateBox(
      {required this.mq, required this.dateText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: mq.height * 0.055,
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(mq.width * 0.08),
          border:
          Border.all(color: Colors.white.withOpacity(0.65), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.035,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.calendar_month_outlined,
                color: Colors.white, size: mq.width * 0.052),
          ],
        ),
      ),
    );
  }
}

class _StatusBox extends StatelessWidget {
  final Size mq;
  const _StatusBox({required this.mq});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.055,
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border:
        Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      ),
      child: Row(
        children: [
          Container(
            height: mq.width * 0.03,
            width: mq.width * 0.03,
            decoration: const BoxDecoration(
              color: Color(0xFF287D80),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: mq.width * 0.025),
          Text(
            "To do",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.035,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create Task Button (with loader) ────────────────────────────────────────

class _CreateTaskButton extends StatelessWidget {
  final double height;
  final VoidCallback? onTap;
  final bool isLoading;

  const _CreateTaskButton({
    required this.height,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: onTap == null
            ? const Color(0xFF287D80).withOpacity(0.55)
            : const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.2,
            ),
          )
              : Text(
            "Create Task",
            style: TextStyle(
              color: Colors.white,
              fontSize: mq.width * 0.037,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Glass Card ───────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final double height;
  final Widget child;
  const _GlassCard({required this.height, required this.child});

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
                color: Colors.white.withOpacity(0.18), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}