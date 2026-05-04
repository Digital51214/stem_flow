import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/services/budget_service.dart';
import 'package:stemflow/Services/session_manager.dart';
import 'package:stemflow/Services/team_list_service.dart';
import 'package:stemflow/models/teams_models.dart';

import 'AddExpenceScreen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool isLoading = false;
  bool isTeamsLoading = false;

  List<MyTeamModel> teams = [];
  MyTeamModel? selectedTeam;

  Map<String, dynamic>? budgetSummary;
  List allocations = [];
  List expenseLog = [];

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

      if (selectedTeam != null) {
        await fetchBudgetDetails();
      }
    } catch (e) {
      showToast("Failed to load teams", color: Colors.red);
    } finally {
      if (mounted) {
        setState(() => isTeamsLoading = false);
      }
    }
  }

  Future<void> fetchBudgetDetails() async {
    if (selectedTeam == null) return;

    setState(() => isLoading = true);

    try {
      final result = await BudgetService.getBudgetDetails(
        teamId: selectedTeam!.id,
      );

      if (!mounted) return;

      setState(() {
        budgetSummary = result["budget_summary"] ?? {};
        allocations = result["allocations"] ?? [];
        expenseLog = result["expense_log"] ?? [];
      });
    } catch (e) {
      showToast(e.toString(), color: Colors.red);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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

  IconData getExpenseIcon(String category) {
    switch (category.toLowerCase()) {
      case "electronics":
        return Icons.bolt_rounded;
      case "materials":
        return Icons.science_outlined;
      case "manufacturing":
        return Icons.inventory_2_outlined;
      case "tools":
        return Icons.construction_rounded;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  double getProgressValue() {
    final raw = budgetSummary?["raw_percentage"] ?? 0;
    final value = double.tryParse(raw.toString()) ?? 0;
    return (value / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final totalSpend = budgetSummary?["total_spend"] ?? "\$0.00";
    final totalBudget = budgetSummary?["total_budget"] ?? "\$0.00";
    final remaining = budgetSummary?["remaining"] ?? "\$0.00";
    final usagePercentage = budgetSummary?["usage_percentage"] ?? "0% of goal";
    final utilizedLabel =
        budgetSummary?["utilized_label"] ?? "0% Budget Utilized";

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
              child: RefreshIndicator(
                color: const Color(0xFF287D80),
                onRefresh: fetchBudgetDetails,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: mq.height * 0.03),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Budget",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mq.width * 0.05,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(width: mq.width * 0.03),
                          _TeamDropdown(
                            mq: mq,
                            teams: teams,
                            selectedTeam: selectedTeam,
                            isLoading: isTeamsLoading,
                            onChanged: (team) {
                              if (team == null) return;

                              setState(() {
                                selectedTeam = team;
                                budgetSummary = null;
                                allocations = [];
                                expenseLog = [];
                              });

                              fetchBudgetDetails();
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: mq.height * 0.02),

                      if (selectedTeam == null && !isTeamsLoading)
                        SizedBox(
                          height: mq.height * 0.35,
                          child: const Center(
                            child: Text(
                              "No teams found",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        _TotalSpendCard(
                          mq: mq,
                          totalSpend: totalSpend,
                          totalBudget: totalBudget,
                          remaining: remaining,
                          usagePercentage: usagePercentage,
                          utilizedLabel: utilizedLabel,
                          progressValue: getProgressValue(),
                        ),

                        SizedBox(height: mq.height * 0.022),

                        if (allocations.isNotEmpty) ...[
                          Text(
                            "Allocations",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mq.width * 0.035,
                              fontFamily: "Mynor",
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: mq.height * 0.012),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allocations.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: mq.height * 0.01),
                            itemBuilder: (context, index) {
                              final item = allocations[index];

                              return _AllocationCard(
                                mq: mq,
                                category: item["category"] ?? "",
                                spent: item["spent"] ?? "\$0.00",
                                percentage: item["percentage"] ?? 0,
                                icon: getExpenseIcon(item["category"] ?? ""),
                              );
                            },
                          ),
                          SizedBox(height: mq.height * 0.022),
                        ],

                        Text(
                          "Expense Log",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: mq.width * 0.035,
                            fontFamily: "Mynor",
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        SizedBox(height: mq.height * 0.012),

                        if (!isLoading && expenseLog.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: mq.height * 0.04),
                            child: Center(
                              child: Text(
                                "No expenses found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mq.width * 0.035,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expenseLog.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: mq.height * 0.01),
                          itemBuilder: (context, index) {
                            final expense = expenseLog[index];

                            return _ExpenseCard(
                              mq: mq,
                              icon: getExpenseIcon(expense["category"] ?? ""),
                              title: expense["item_name"] ?? "",
                              category: expense["category"] ?? "",
                              price: expense["amount"] ?? "",
                              date: expense["date"] ?? "",
                            );
                          },
                        ),

                        SizedBox(height: mq.height * 0.028),

                        _AddExpenseButton(
                          mq: mq,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddExpenseScreen(),
                              ),
                            );

                            fetchBudgetDetails();
                          },
                        ),
                      ],

                      SizedBox(height: mq.height * 0.07),
                    ],
                  ),
                ),
              ),
            ),

            if (isLoading || isTeamsLoading)
              Container(
                color: Colors.black.withOpacity(0.35),
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
      height: mq.height * 0.046,
      width: mq.width * 0.34,
      child: DropdownButtonFormField<MyTeamModel>(
        value: selectedTeam,
        isExpanded: true,
        dropdownColor: const Color(0xFF287D80),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: mq.width * 0.045,
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
                fontSize: mq.width * 0.027,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }).toList(),
        onChanged: isLoading ? null : onChanged,
        hint: Text(
          isLoading ? "Loading..." : "Teams",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: mq.width * 0.027,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w700,
          ),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.035,
            vertical: 0,
          ),
          filled: true,
          fillColor: const Color(0xFF4EB7BD).withOpacity(0.48),
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

class _TotalSpendCard extends StatelessWidget {
  final Size mq;
  final String totalSpend;
  final String totalBudget;
  final String remaining;
  final String usagePercentage;
  final String utilizedLabel;
  final double progressValue;

  const _TotalSpendCard({
    required this.mq,
    required this.totalSpend,
    required this.totalBudget,
    required this.remaining,
    required this.usagePercentage,
    required this.utilizedLabel,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return _GlassCard(
      mq: mq,
      height: mq.height * 0.19,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.07,
          vertical: mq.height * 0.017,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TOTAL SPEND",
              style: TextStyle(
                color: teal,
                fontSize: mq.width * 0.03,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: mq.height * 0.005),
            Text(
              totalSpend,
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.058,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: mq.height * 0.006),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Budget: $totalBudget",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.026,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "Remaining: $remaining",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.026,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.width * 0.03),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: mq.height * 0.006,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF287D80),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: mq.width * 0.022),
                Text(
                  usagePercentage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.024,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * 0.006),
            Text(
              utilizedLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.024,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  final Size mq;
  final String category;
  final String spent;
  final int percentage;
  final IconData icon;

  const _AllocationCard({
    required this.mq,
    required this.category,
    required this.spent,
    required this.percentage,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      mq: mq,
      height: mq.height * 0.086,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.048),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: mq.width * 0.052),
            SizedBox(width: mq.width * 0.035),
            Expanded(
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.034,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              spent,
              style: TextStyle(
                color: const Color(0xFF287D80),
                fontSize: mq.width * 0.031,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(width: mq.width * 0.02),
            Text(
              "$percentage%",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.026,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Size mq;
  final IconData icon;
  final String title;
  final String category;
  final String price;
  final String date;

  const _ExpenseCard({
    required this.mq,
    required this.icon,
    required this.title,
    required this.category,
    required this.price,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return _GlassCard(
      mq: mq,
      height: mq.height * 0.108,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.048),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: mq.width * 0.058),
            SizedBox(width: mq.width * 0.04),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: mq.height * 0.004),
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.026,
                      fontFamily: "Mynor",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: mq.width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  maxLines: 1,
                  style: TextStyle(
                    color: teal,
                    fontSize: mq.width * 0.031,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: mq.height * 0.006),
                Text(
                  date,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.022,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddExpenseButton extends StatelessWidget {
  final Size mq;
  final VoidCallback onTap;

  const _AddExpenseButton({
    required this.mq,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mq.height * 0.057,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: mq.width * 0.052,
            ),
            SizedBox(width: mq.width * 0.012),
            Text(
              "Add Expense",
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

class _GlassCard extends StatelessWidget {
  final Size mq;
  final double height;
  final Widget child;

  const _GlassCard({
    required this.mq,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
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