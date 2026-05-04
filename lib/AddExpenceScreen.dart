import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/services/add_expense_service.dart';
import 'package:stemflow/Services/session_manager.dart';
import 'package:stemflow/Services/team_list_service.dart';
import 'package:stemflow/models/teams_models.dart';

import 'BottomNavigation_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedCategory = "Materials";

  bool isLoading = false;
  bool isTeamsLoading = false;

  List<MyTeamModel> teams = [];
  MyTeamModel? selectedTeam;

  final String apiKey = "YOUR_API_KEY_HERE";

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    setState(() => isTeamsLoading = true);

    try {
      final userIdText = await SessionManager.instance.getUserId();
      final userId = int.tryParse(userIdText) ?? 0;

      final result = await MyTeamService.getMyTeams(
        userId: userId,
        apiKey: apiKey,
      );

      if (!mounted) return;

      setState(() {
        teams = result;
        if (teams.isNotEmpty) {
          selectedTeam = teams.first;
        }
      });
    } catch (e) {
      showToast("Failed to load teams");
    } finally {
      if (mounted) {
        setState(() => isTeamsLoading = false);
      }
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void showToast(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? const Color(0xFF287D80),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Future<void> handleAddExpense() async {
    final itemName = itemNameController.text.trim();
    final amountText = amountController.text.trim();
    final date = dateController.text.trim();
    final amount = double.tryParse(amountText);

    if (selectedTeam == null) {
      showToast("Please select team");
      return;
    }

    if (itemName.isEmpty || amountText.isEmpty || date.isEmpty) {
      showToast("Please fill all fields");
      return;
    }

    if (amount == null || amount <= 0) {
      showToast("Please enter valid amount");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ExpenseService.addExpense(
        teamId: selectedTeam!.id,
        itemName: itemName,
        category: selectedCategory,
        amount: amount,
        date: date,
      );

      showToast(result["message"] ?? "Expense saved successfully");

      itemNameController.clear();
      amountController.clear();
      dateController.clear();

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
            (route) => false,
      );
    } catch (e) {
      showToast(e.toString(), color: Colors.red);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
                      Colors.white.withOpacity(0.88),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.055),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: mq.height * 0.045),
                    Row(
                      children: [
                        BackCircle(onTap: () => Navigator.pop(context)),
                        const Spacer(),
                        Container(
                          height: mq.height * 0.06,
                          width: mq.width * 0.13,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Logo.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.03),
                    Text(
                      "Add Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: mq.height * 0.03),
                    _GlassFormCard(
                      mq: mq,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.06,
                          vertical: mq.height * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel(mq: mq, title: "TEAM"),
                            SizedBox(height: mq.height * 0.012),
                            _TeamDropdown(
                              mq: mq,
                              teams: teams,
                              selectedTeam: selectedTeam,
                              isLoading: isTeamsLoading,
                              onChanged: (team) {
                                if (team == null) return;
                                setState(() => selectedTeam = team);
                              },
                            ),

                            SizedBox(height: mq.height * 0.024),

                            _FieldLabel(mq: mq, title: "ITEM NAME"),
                            SizedBox(height: mq.height * 0.012),
                            _ExpenseTextField(
                              mq: mq,
                              controller: itemNameController,
                              hintText: "e.g. Aerodynamic Carbon Sheet",
                            ),

                            SizedBox(height: mq.height * 0.024),

                            _FieldLabel(mq: mq, title: "CATEGORY"),
                            SizedBox(height: mq.height * 0.012),
                            _CategoryDropdown(
                              mq: mq,
                              value: selectedCategory,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedCategory = value);
                                }
                              },
                            ),

                            SizedBox(height: mq.height * 0.024),

                            _FieldLabel(mq: mq, title: "AMOUNT"),
                            SizedBox(height: mq.height * 0.012),
                            _ExpenseTextField(
                              mq: mq,
                              controller: amountController,
                              hintText: "0.00",
                              prefixText: "\$ ",
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),

                            SizedBox(height: mq.height * 0.024),

                            _FieldLabel(mq: mq, title: "DATE"),
                            SizedBox(height: mq.height * 0.012),
                            _ExpenseTextField(
                              mq: mq,
                              controller: dateController,
                              hintText: "Select date",
                              readOnly: true,
                              suffixIcon: Icons.calendar_month_outlined,
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                  initialDate: DateTime.now(),
                                );

                                if (pickedDate != null) {
                                  dateController.text =
                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * 0.038),
                    _SaveExpenseButton(
                      mq: mq,
                      onTap: isLoading ? null : handleAddExpense,
                      isLoading: isLoading,
                    ),
                    SizedBox(height: mq.height * 0.08),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TeamDropdown extends StatelessWidget {
  final Size mq;
  final List<MyTeamModel> teams;
  final MyTeamModel? selectedTeam;
  final bool isLoading;
  final ValueChanged<MyTeamModel?> onChanged;

  const _TeamDropdown({
    required this.mq,
    required this.teams,
    required this.selectedTeam,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.058,
      child: DropdownButtonFormField<MyTeamModel>(
        value: selectedTeam,
        isExpanded: true,
        dropdownColor: const Color(0xFF4EB7BD),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: mq.width * 0.065,
        ),
        items: teams.map((team) {
          return DropdownMenuItem<MyTeamModel>(
            value: team,
            child: Text(
              team.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.03,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
        onChanged: isLoading ? null : onChanged,
        hint: Text(
          isLoading ? "Loading teams..." : "Select Team",
          style: TextStyle(
            color: Colors.white,
            fontSize: mq.width * 0.03,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.05,
            vertical: mq.height * 0.012,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.65),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final Size mq;
  final String title;

  const _FieldLabel({
    required this.mq,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: mq.width * 0.028,
        fontFamily: "Mynor",
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }
}

class _ExpenseTextField extends StatelessWidget {
  final Size mq;
  final TextEditingController controller;
  final String hintText;
  final String? prefixText;
  final IconData? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const _ExpenseTextField({
    required this.mq,
    required this.controller,
    required this.hintText,
    this.prefixText,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.058,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.white,
          fontSize: mq.width * 0.026,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixText: prefixText,
          prefixStyle: TextStyle(
            color: Colors.white,
            fontSize: mq.width * 0.026,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: mq.width * 0.026,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Icon(
            suffixIcon,
            color: Colors.white,
            size: mq.width * 0.047,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.055,
            vertical: mq.height * 0.014,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.65),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  final Size mq;
  final String value;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({
    required this.mq,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.058,
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF4EB7BD),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: mq.width * 0.065,
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: mq.width * 0.03,
          fontFamily: "Mynor",
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.05,
            vertical: mq.height * 0.012,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.65),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(mq.width * 0.08),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.9),
              width: 1,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(value: "Materials", child: Text("Materials")),
          DropdownMenuItem(value: "Manufacturing", child: Text("Manufacturing")),
          DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
          DropdownMenuItem(value: "Tools", child: Text("Tools")),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

class _SaveExpenseButton extends StatelessWidget {
  final Size mq;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SaveExpenseButton({
    required this.mq,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.058,
      width: double.infinity,
      decoration: BoxDecoration(
        color: onTap == null
            ? const Color(0xFF287D80).withOpacity(0.55)
            : const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF287D80).withOpacity(0.32),
            blurRadius: mq.width * 0.012,
            offset: Offset(0, mq.height * 0.003),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Center(
          child: isLoading
              ? SizedBox(
            height: mq.width * 0.05,
            width: mq.width * 0.05,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.save_outlined,
                color: Colors.white,
                size: mq.width * 0.04,
              ),
              SizedBox(width: mq.width * 0.018),
              Text(
                "Save Expense",
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
      ),
    );
  }
}

class _GlassFormCard extends StatelessWidget {
  final Size mq;
  final Widget child;

  const _GlassFormCard({
    required this.mq,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: mq.height * 0.64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.48),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}