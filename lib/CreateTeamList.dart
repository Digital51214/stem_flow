import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:stemflow/AddMemberScreen.dart';
import 'package:stemflow/Widgets/backcircle.dart';
import 'package:stemflow/Widgets/background.dart';

class TeamMemberListScreen extends StatefulWidget {
  const TeamMemberListScreen({super.key});

  @override
  State<TeamMemberListScreen> createState() => _TeamMemberListScreenState();
}

class _TeamMemberListScreenState extends State<TeamMemberListScreen> {
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

                    Row(
                      children: [
                        BackCircle(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        Container(
                          height: 44,
                          width: 45,
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

                    const Text(
                      "Lynx Racing Squad",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Mynor",
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    SizedBox(height: mq.height*0.015),

                    const _DashedInfoBox(),

                    const SizedBox(height: 18),

                    _AddMembersButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddMemberScreen()));
                      },
                    ),

                    SizedBox(height: mq.height*0.029),

                    const _MemberCard(
                      imagePath: "assets/images/image 1.png",
                      name: "Marcus Thorne",
                      role: "LEAD ENGINEER",
                      status: "ON TRACK",
                      progress: 0.85,
                    ),

                    SizedBox(height: mq.height*0.01),

                    const _MemberCard(
                      imagePath: "assets/images/image 2.png",
                      name: "Elena Rodriguez",
                      role: "TEAM MANAGER",
                      status: "PIT STOP",
                      progress: 0.0,
                    ),

                    const SizedBox(height: 30),
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

class _DashedInfoBox extends StatelessWidget {
  const _DashedInfoBox();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: Colors.white,
        radius: 20,
        strokeWidth: 1.4,
        dashWidth: 4,
        dashSpace: 4,
      ),
      child: Container(
        height: mq.height*0.117,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 13),
        alignment: Alignment.centerLeft,
        child: const Text(
          "No members added yet to the reserve roster.\n"
              "Recruit additional talent to strengthen the Lynx\n"
              "squad.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.7,
            height: 1.25,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _AddMembersButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddMembersButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height*0.058,
      decoration: BoxDecoration(
        color: const Color(0xFF287D80),
        borderRadius: BorderRadius.circular(35),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(35),
        onTap: onTap,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Members",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "Mynor",
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final String status;
  final double progress;

  const _MemberCard({
    required this.imagePath,
    required this.name,
    required this.role,
    required this.status,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return _GlassCard(
      height: mq.height*0.2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagePath)),
                  ),
                ),
                SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role,
                        style: const TextStyle(
                          color: Color(0xFF287D80),
                          fontSize: 10,
                          fontFamily: "Mynor",
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.more_vert,
                  color: Color(0xFF287D80),
                  size: 25,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Divider(
              color: Colors.white.withOpacity(0.95),
              thickness: 1,
              height: 1,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFF287D80),
                    fontSize: 12,
                    fontFamily: "Mynor",
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withOpacity(0.75),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF287D80),
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
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF4EB7BD).withOpacity(0.5),
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
        final dashPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(dashPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}