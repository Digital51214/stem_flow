import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/SelectMethodologyScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class PhaseDetailsScreen extends StatefulWidget {
  const PhaseDetailsScreen({super.key});

  @override
  State<PhaseDetailsScreen> createState() => _PhaseDetailsScreenState();
}

class _PhaseDetailsScreenState extends State<PhaseDetailsScreen> {
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
                      "Phase Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.028),

                    _GlassCard(
                      height: mq.height * 0.17,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.05,
                          vertical: mq.height * 0.022,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: mq.height * 0.023,
                              width: mq.width * 0.225,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  mq.width * 0.008,
                                ),
                              ),
                              child: Text(
                                "ACTIVE PHASE",
                                style: TextStyle(
                                  color: const Color(0xFF287D80),
                                  fontSize: mq.width * 0.016,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: mq.height * 0.018),

                            Text(
                              "Design Phase",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mq.width * 0.036,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            SizedBox(height: mq.height * 0.008),

                            Text(
                              "Initial aerodynamic simulations and component topology\n"
                                  "optimization for the 2024 chassis upgrade.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mq.width * 0.02,
                                height: 1.5,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.018),

                    _GlassCard(
                      height: mq.height * 0.455,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.05,
                          vertical: mq.height * 0.028,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Methodology",
                                  style: TextStyle(
                                    color: const Color(0xFF287D80),
                                    fontSize: mq.width * 0.03,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "No configuration detected",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mq.width * 0.02,
                                    fontFamily: "Mynor",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: mq.height * 0.009),

                            Divider(
                              color: Colors.white.withOpacity(0.9),
                              thickness: 1,
                              height: 1,
                            ),

                            SizedBox(height: mq.height * 0.021),

                            Container(
                              height: mq.width * 0.13,
                              width: mq.width * 0.13,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.account_tree_outlined,
                                color: const Color(0xFF287D80),
                                size: mq.width * 0.06,
                              ),
                            ),

                            SizedBox(height: mq.height * 0.02),

                            Text(
                              "No methodology selected",
                              style: TextStyle(
                                color: const Color(0xFF287D80),
                                fontSize: mq.width * 0.034,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            SizedBox(height: mq.height * 0.012),

                            Text(
                              "Define the workflow structure for this\n"
                                  "phase to track telemetry and engineering\n"
                                  "milestones effectively.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mq.width * 0.028,
                                height: 1.5,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const Spacer(),

                            _SelectMethodButton(
                              height: mq.height * 0.055,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectMethodologyScreen()));
                              },
                            ),

                            SizedBox(height: mq.height * 0.026),

                            Center(
                              child: Text(
                                "Browse Templates",
                                style: TextStyle(
                                  color: const Color(0xFF287D80),
                                  fontSize: mq.width * 0.036,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: mq.height * 0.18),
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

class _SelectMethodButton extends StatelessWidget {
  final double height;
  final VoidCallback onTap;

  const _SelectMethodButton({
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on_rounded,
              color: Colors.white,
              size: mq.width * 0.055,
            ),
            SizedBox(width: mq.width * 0.018),
            Text(
              "Select Methodology",
              style: TextStyle(
                color: Colors.white,
                fontSize: mq.width * 0.037,
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