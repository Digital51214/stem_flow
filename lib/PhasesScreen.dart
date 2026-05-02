import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/CreatePhaseScreen.dart';
import 'package:stemflow/Widgets/background.dart';

class Phasesscreen extends StatefulWidget {
  const Phasesscreen({super.key});

  @override
  State<Phasesscreen> createState() => _PhasesscreenState();
}

class _PhasesscreenState extends State<Phasesscreen> {
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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: mq.height * 0.035),

                    Container(
                      height: 44,
                      width: 45,
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

                    const Text(
                      "Project Phases",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height*0.025),

                    SizedBox(
                      height: mq.height*0.1,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: const [
                          SizedBox(width: 52, child: _DateCard(day: "MON", date: "24")),
                          SizedBox(width: 14),
                          SizedBox(
                            width: 53,
                            child: _DateCard(
                              day: "TUE",
                              date: "25",
                              isSelected: true,
                            ),
                          ),
                          SizedBox(width: 14),
                          SizedBox(width: 52, child: _DateCard(day: "WED", date: "26")),
                          SizedBox(width: 14),
                          SizedBox(width: 52, child: _DateCard(day: "THU", date: "27")),
                          SizedBox(width: 14),
                          SizedBox(width: 52, child: _DateCard(day: "FRI", date: "28")),
                          SizedBox(width: 14),
                          SizedBox(width: 52, child: _DateCard(day: "SAT", date: "29")),
                          SizedBox(width: 14),
                          SizedBox(width: 52, child: _DateCard(day: "SUN", date: "30")),
                        ],
                      ),
                    ),

                    SizedBox(height: mq.height*0.028),

                    _TimelinePhaseCard(
                      time: "09:00 AM",
                      icon: Icons.check_rounded,
                      timelineColor: const Color(0xFF28EBD9),
                      cardIcon: Icons.science_outlined,
                      title: "Aerodynamics Review",
                      tag: "DESIGN",
                      status: "Completed",
                      showLineTop: false,
                      showLineBottom: true,
                      progressDot: false,
                    ),

                    SizedBox(height: mq.height*0.018),

                    _TimelinePhaseCard(
                      time: "11:30 AM — ONGOING",
                      icon: Icons.circle,
                      timelineColor: Colors.white,
                      cardIcon: Icons.groups_rounded,
                      title: "Team Standup",
                      tag: "MANAGEMENT",
                      status: "",
                      showLineTop: true,
                      showLineBottom: true,
                      progressDot: true,
                      showAvatars: true,
                    ),


                    _TimelinePhaseCard(
                      time: "02:00 PM",
                      icon: Icons.circle,
                      timelineColor: Colors.white,
                      cardIcon: Icons.precision_manufacturing_outlined,
                      title: "Chassis Stress Test",
                      tag: "TESTING",
                      status: "Upcoming",
                      showLineTop: true,
                      showLineBottom: false,
                      progressDot: false,
                    ),

                    SizedBox(height: mq.height*0.028),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePhaseScreen()));
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFF287D80),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,color: Colors.white,),
                            Text("Create Phase",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                              )
                          ]
                        ),
                      ),
                    ),


                    //  _AddPhaseBox(
                    //   onTap: () {
                    //     Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePhaseScreen()));
                    //   },
                    // ),

                    SizedBox(height: mq.height*0.03),

                    _EfficiencyCard(),

                    SizedBox(height: mq.height*0.054),
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

class _DateCard extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;

  const _DateCard({
    required this.day,
    required this.date,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return _GlassCard(
      height: mq.height*0.84,
      radius: 14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w900,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 6),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelinePhaseCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final Color timelineColor;
  final IconData cardIcon;
  final String title;
  final String tag;
  final String status;
  final bool showLineTop;
  final bool showLineBottom;
  final bool progressDot;
  final bool showAvatars;

  const _TimelinePhaseCard({
    required this.time,
    required this.icon,
    required this.timelineColor,
    required this.cardIcon,
    required this.title,
    required this.tag,
    required this.status,
    required this.showLineTop,
    required this.showLineBottom,
    required this.progressDot,
    this.showAvatars = false,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final double lineHeight = showAvatars ? mq.height*0.14 : mq.height*0.11;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Column(
            children: [
              if (showLineTop)
                Container(
                  width: 2,
                  height: 20,
                  color: const Color(0xFF287D80).withOpacity(0.75),
                )
              else
                const SizedBox(height: 0),

              Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: timelineColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: progressDot
                      ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF28EBD9),
                      shape: BoxShape.circle,
                    ),
                  )
                      : Icon(
                    icon,
                    color: const Color(0xFF287D80),
                    size: 16,
                  ),
                ),
              ),

              if (showLineBottom)
                Container(
                  width: 2,
                  height: lineHeight,
                  color: const Color(0xFF287D80).withOpacity(0.75),
                ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              _GlassCard(
                height: showAvatars ? mq.height*0.14 : mq.height*0.1,
                radius: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Icon(
                            cardIcon,
                            color: const Color(0xFF287D80),
                            size: 18,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Color(0xFF287D80),
                                fontSize: 8,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                          if (status.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(0xFF287D80),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              status,
                              style: const TextStyle(
                                color: Color(0xFF287D80),
                                fontSize: 9,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (showAvatars) ...[
                        const SizedBox(height: 12),
                        const _AvatarStack(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SizedBox(
      width: mq.height*0.12,
      height: 24,
      child: Stack(
        children: [
          _SmallAvatar(left: 0, imagePath: "assets/images/member1.png"),
          _SmallAvatar(left: 18, imagePath: "assets/images/member2.png"),
          _SmallAvatar(left: 36, imagePath: "assets/images/member3.png"),
          Positioned(
            left: 54,
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1E5557),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF287D80),
                  width: 2,
                ),
              ),
              child: const Text(
                "+2",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAvatar extends StatelessWidget {
  final double left;
  final String imagePath;

  const _SmallAvatar({
    required this.left,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Positioned(
      left: left,
      child: CircleAvatar(
        radius: 12.5,
        backgroundColor: const Color(0xFF287D80),
        child: CircleAvatar(
          radius: 10.5,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}

// class _AddPhaseBox extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const _AddPhaseBox({
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: onTap,
//       child: CustomPaint(
//         painter: _DashedBorderPainter(
//           color: Colors.white,
//           radius: 10,
//           strokeWidth: 1.6,
//           dashWidth: 5,
//           dashSpace: 5,
//         ),
//         child: Container(
//           height: mq.height*0.18,
//           width: double.infinity,
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: const Icon(
//                   Icons.add,
//                   color: Color(0xFF287D80),
//                   size: 25,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Add New Phase",
//                 style: TextStyle(
//                   color: Color(0xFF287D80),
//                   fontSize: 16,
//                   fontFamily: "Mynor",
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class _EfficiencyCard extends StatelessWidget {
  const _EfficiencyCard();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height*0.16,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PHASE EFFICIENCY",
            style: TextStyle(
              color: Color(0xFF287D80),
              fontSize: 9,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "94%",
            style: TextStyle(
              color: Color(0xFF287D80),
              fontSize: 44,
              height: 0.95,
              fontFamily: "Mynor",
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF287D80),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                "+2.4% vs last project",
                style: TextStyle(
                  color: Color(0xFF287D80),
                  fontSize: 11,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final double height;
  final double radius;
  final Widget child;

  const _GlassCard({
    required this.height,
    required this.child,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.9)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rRect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}