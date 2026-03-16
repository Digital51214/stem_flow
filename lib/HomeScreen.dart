import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/Widgets/background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(
        child: Stack(
          children: [
            // ✅ Background (teal top -> light bottom, like image)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
        
                    // ✅ Top Right Notification Button
                    Row(
                      children: [
                        Container(
                          height: 44,
                          width: 45,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage("assets/images/Logo.png")),
                          ),
                        ),
                        Spacer(),
                        _RoundIconButton(
                          icon: Icons.notifications,
                          onTap: () {},
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 14),
        
                    // ✅ Current Phase Card
                    _GlassCard(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.75),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Text(
                                    "Active Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: "Mynor",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Design Phase",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
        
                            // progress row
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
                                  "65%",
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
                                value: 0.35,
                                minHeight: 8,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff4EB7BD).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        
                    const SizedBox(height: 12),
        
                    // ✅ 3 Small Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _SmallStatCard(
                            icon: Icons.format_list_bulleted_rounded,
                            value: "12",
                            label: "Tasks",
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
                            value: "68%",
                            label: "Success",
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 16),
        
                    // ✅ Budget Overview Card
                    _GlassCard(
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0,left: 15,right: 15,bottom: 10),
                        child: Column(
                          children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Budget Overview",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "Mynor",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                                  // Row(
                            //   children: [
                            //     // left: circular budget
                            //     SizedBox(
                            //       width: 98,
                            //       height: 98,
                            //       child: Stack(
                            //         alignment: Alignment.center,
                            //         children: [
                            //           SizedBox(
                            //             width: 70,
                            //             height: 70,
                            //             child: CircularProgressIndicator(
                            //               value: 0.72,
                            //               strokeWidth: 8,
                            //               backgroundColor:
                            //               Colors.white.withOpacity(0.22),
                            //               valueColor:
                            //               const AlwaysStoppedAnimation<Color>(
                            //                 Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //           Container(
                            //             width: 67,
                            //             height: 67,
                            //             decoration: BoxDecoration(
                            //               color: Colors.white.withOpacity(0.12),
                            //               shape: BoxShape.circle,
                            //             ),
                            //             alignment: Alignment.center,
                            //             child: const Text(
                            //               "420\$",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.w800,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //
                            //     const SizedBox(width: 14),
                            //
                            //     // right: title + legend
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Row(
                            //             children: [
                            //               Container(
                            //                 width: 24,
                            //                 height: 24,
                            //                 decoration: BoxDecoration(
                            //                   color: Colors.white.withOpacity(0.18),
                            //                   borderRadius: BorderRadius.circular(6),
                            //                 ),
                            //                 child: const Icon(
                            //                   Icons.attach_money_rounded,
                            //                   color: Colors.white,
                            //                   size: 18,
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 10),
                            //               const Text(
                            //                 "Budget Overview",
                            //                 style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 12,
                            //                   fontWeight: FontWeight.w800,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           const Spacer(),
                            //
                            //           _LegendRow(
                            //             dotColor: Color(0xff287D80),
                            //             text: "Materials: 210",
                            //           ),
                            //           const SizedBox(height: 10),
                            //           _LegendRow(
                            //             dotColor: Colors.white,
                            //             text: "Remaining",
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            ],
                          ),
                            SizedBox(height: 10,),
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
                                          value: 0.72,
                                          strokeWidth: 5,
                                          backgroundColor:
                                          Colors.white.withOpacity(0.22),
                                          valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
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
                                SizedBox(width: 16,),
                                Column(
                                  children: [
                                    _LegendRow(
                                      dotColor: Color(0xff287D80),
                                      text: "Materials: 210",
                                    ),
                                    const SizedBox(height: 10),
                                    _LegendRow(
                                      dotColor: Colors.white,
                                      text: "Remaining",
                                    ),

                                  ],
                                )

                              ],

                            )
                          ],
                      ),
                    ),
                    ),
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

/// ✅ Glass Card (blur + rounded + border)
class _GlassCard extends StatelessWidget {
  final double height;
  final Widget child;

  const _GlassCard({
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD),
            borderRadius: BorderRadius.circular(22),
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

class _SmallStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SmallStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      height: 96,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: "Mynor",
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                fontFamily: "Mynor",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color dotColor;
  final String text;

  const _LegendRow({
    required this.dotColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.90),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontFamily: "Mynor",
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
  });

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
            offset: const Offset(0, 6),
          )
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