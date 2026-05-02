import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/BottomNavigation_screen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class SelectMethodologyScreen extends StatefulWidget {
  const SelectMethodologyScreen({super.key});

  @override
  State<SelectMethodologyScreen> createState() =>
      _SelectMethodologyScreenState();
}

class _SelectMethodologyScreenState extends State<SelectMethodologyScreen> {
  int selectedIndex = 0;

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

                    Row(
                      children: [
                        BackCircle(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
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

                    SizedBox(height: mq.height * 0.04),

                    Text(
                      "Select Methodology",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.041,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.024),

                    _MethodologyCard(
                      isSelected: selectedIndex == 0,
                      icon: Icons.account_tree_outlined,
                      title: "Structured",
                      description:
                      "A linear, phase-gated approach for high-\n"
                          "compliance projects with fixed milestones.",
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _MethodologyCard(
                      isSelected: selectedIndex == 1,
                      icon: Icons.dashboard_outlined,
                      title: "Flexible",
                      description:
                      "Adaptive task management allowing for a\n"
                          "rapid changes on the fly resource.",
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _MethodologyCard(
                      isSelected: selectedIndex == 2,
                      icon: Icons.sync_rounded,
                      title: "Iterative",
                      description:
                      "Rapid sprint-based development focused\n"
                          "on the continuous feedback.",
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                    ),

                    SizedBox(height: mq.height * 0.05),

                    _SaveMethodologyButton(
                      height: mq.height * 0.056,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WidgetTree()),
                            (Route<dynamic>route)=>false);
                      },
                    ),

                    SizedBox(height: mq.height * 0.03),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: const Color(0xFF287D80),
                            fontSize: mq.width * 0.037,
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

class _MethodologyCard extends StatelessWidget {
  final bool isSelected;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MethodologyCard({
    required this.isSelected,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: _GlassCard(
        height: mq.height * 0.17,
        child: Stack(
          children: [
            Positioned(
              left: mq.width * 0.05,
              top: mq.height * 0.065,
              child: Container(
                height: mq.width * 0.062,
                width: mq.width * 0.062,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xFF287D80).withOpacity(0.85)
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF287D80)
                        : Colors.white,
                    width: 1.3,
                  ),
                ),
                child: isSelected
                    ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: mq.width * 0.034,
                )
                    : null,
              ),
            ),

            Positioned(
              left: mq.width * 0.135,
              top: mq.height * 0.035,
              right: mq.width * 0.07,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: mq.width * 0.06,
                  ),
                  SizedBox(width: mq.width * 0.025),
                  Text(
                    title,
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

            Positioned(
              left: mq.width * 0.135,
              right: mq.width * 0.06,
              top: mq.height * 0.084,
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.024,
                  height: 1.5,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
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

class _SaveMethodologyButton extends StatelessWidget {
  final double height;
  final VoidCallback onTap;

  const _SaveMethodologyButton({
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(mq.width * 0.09),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(mq.width * 0.09),
        onTap: onTap,
        child: Center(
          child: Text(
            "Save Methodology",
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