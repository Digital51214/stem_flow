import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class AIInsightsScreen extends StatelessWidget {
  const AIInsightsScreen({super.key});

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
                      "AI Insights",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mq.width * 0.05,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height * 0.026),

                    _InsightCard(
                      mq: mq,
                      tag: "WORK LOAD",
                      topIcon: Icons.bar_chart_rounded,
                      message:
                      "You have assigned multiple tasks to one member.\nConsider distributing workload to maintain team\nvelocity.",
                      bottomIcon: Icons.info_outline_rounded,
                      bottomText: "Optimization Recommended",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _InsightCard(
                      mq: mq,
                      tag: "DEADLINE",
                      topIcon: Icons.access_time_rounded,
                      message:
                      "Two tasks have the same deadline. Consider the\nadjusting the schedule to avoid resource bottlenecks.",
                      bottomIcon: Icons.warning_amber_rounded,
                      bottomText: "Schedule Risk Detected",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _InsightCard(
                      mq: mq,
                      tag: "VELOCITY",
                      topIcon: Icons.speed_rounded,
                      message:
                      "Current sprint velocity is 15% above the baseline.\nEngineering performance is peaking in the final sector.",
                      bottomIcon: Icons.check_circle_outline_rounded,
                      bottomText: "Performance Optimal",
                    ),

                    SizedBox(height: mq.height * 0.01),

                    _InsightCard(
                      mq: mq,
                      tag: "RESOURCE",
                      topIcon: Icons.groups_2_outlined,
                      message:
                      "Designer availibility increases on Monday.\nQueue visual assets for the next phase accordingly.",
                      bottomIcon: Icons.calendar_today_outlined,
                      bottomText: "Planning Opportunity",
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

class _InsightCard extends StatelessWidget {
  final Size mq;
  final String tag;
  final IconData topIcon;
  final String message;
  final IconData bottomIcon;
  final String bottomText;

  const _InsightCard({
    required this.mq,
    required this.tag,
    required this.topIcon,
    required this.message,
    required this.bottomIcon,
    required this.bottomText,
  });

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF287D80);

    return ClipRRect(
      borderRadius: BorderRadius.circular(mq.width * 0.055),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: mq.height * 0.17,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.058,
            vertical: mq.height * 0.024,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.48),
            borderRadius: BorderRadius.circular(mq.width * 0.055),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: mq.height * 0.021,
                    width: mq.width * 0.225,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(mq.width * 0.007),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: teal,
                        fontSize: mq.width * 0.02,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(width: mq.width * 0.022),

                  Icon(
                    topIcon,
                    color: Colors.white,
                    size: mq.width * 0.045,
                  ),
                ],
              ),

              SizedBox(height: mq.height * 0.016),

              Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: mq.width * 0.022,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Icon(
                    bottomIcon,
                    color: teal,
                    size: mq.width * 0.031,
                  ),
                  SizedBox(width: mq.width * 0.014),
                  Expanded(
                    child: Text(
                      bottomText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: teal,
                        fontSize: mq.width * 0.028,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}