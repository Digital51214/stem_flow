import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/AddExpenceScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';
import 'package:stemflow/services/budget_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  bool isLoading = false;
  List expenseLog = [];

  @override
  void initState() {
    super.initState();
    fetchBudgetDetails();
  }

  Future<void> fetchBudgetDetails() async {
    setState(() => isLoading = true);

    try {
      final result = await BudgetService.getBudgetDetails(teamId: 2);

      print("✅ BUDGET API SUCCESS");
      print("✅ FULL RESULT: $result");

      setState(() {
        expenseLog = result["expense_log"] ?? [];
      });

      print("✅ EXPENSE LOG LENGTH: ${expenseLog.length}");
    } catch (e) {
      print("❌ BUDGET API ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
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

  double getTotalSpend() {
    double total = 0;

    for (final item in expenseLog) {
      final amountText = item["amount"].toString().replaceAll("\$", "").replaceAll(",", "");
      total += double.tryParse(amountText) ?? 0;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final totalSpend = getTotalSpend();

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
                          BackCircle(
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
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

                      Text(
                        "Budget",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mq.width * 0.05,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      SizedBox(height: mq.height * 0.02),

                      _TotalSpendCard(
                        mq: mq,
                        totalSpend: "\$${totalSpend.toStringAsFixed(2)}",
                      ),

                      SizedBox(height: mq.height * 0.022),

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
                        separatorBuilder: (context, index) {
                          return SizedBox(height: mq.height * 0.01);
                        },
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
                              builder: (context) => const AddExpenseScreen(),
                            ),
                          );

                          fetchBudgetDetails();
                        },
                      ),

                      SizedBox(height: mq.height * 0.07),
                    ],
                  ),
                ),
              ),
            ),

            if (isLoading)
              Container(
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
    );
  }
}

class _TotalSpendCard extends StatelessWidget {
  final Size mq;
  final String totalSpend;

  const _TotalSpendCard({
    required this.mq,
    required this.totalSpend,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return _GlassCard(
      mq: mq,
      height: mq.height * 0.135,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.07,
          vertical: mq.height * 0.015,
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

            SizedBox(height: mq.height * 0.006),

            Text(
              totalSpend,
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.06,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.width * 0.03),
                    child: LinearProgressIndicator(
                      value: 0.75,
                      minHeight: mq.height * 0.0055,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF287D80),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: mq.width * 0.022),

                Text(
                  "75% of goal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: mq.width * 0.026,
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
            Icon(
              icon,
              color: Colors.white,
              size: mq.width * 0.058,
            ),

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
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
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