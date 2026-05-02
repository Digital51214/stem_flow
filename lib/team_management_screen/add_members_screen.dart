import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stemflow/Widgets/background.dart';

class AddMemberScreen1 extends StatefulWidget {
  const AddMemberScreen1({super.key});

  @override
  State<AddMemberScreen1> createState() => _AddMemberScreen1State();
}

class _AddMemberScreen1State extends State<AddMemberScreen1> {
  final String inviteCode = "STEMFLOW123";
  final TextEditingController roleController = TextEditingController();

  void copyCode() {
    Clipboard.setData(ClipboardData(text: inviteCode));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Invite code copied",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF287D80),
      ),
    );
  }

  @override
  void dispose() {
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Bg(

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Color(0xFF287D80),
                                  size: 18,
                                ),
                              ),
                            ),
                            Image.asset(
                              "assets/images/Logo.png",
                              height: 47,
                              width: 47,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Lynx Racing Squad",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Mynor",
                          ),
                        ),

                        const SizedBox(height: 16),

                        CustomPaint(
                          painter: DashedBorderPainter(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 22,
                            ),
                            child: const Text(
                              "No members added yet to the reserve roster.\nRecruit additional talent to strengthen the Lynx\nsquad.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.25,
                                fontFamily: "Mynor",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Add Member",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Mynor",
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(30, 27, 30, 26),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6FC7C8).withOpacity(0.45),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ASSIGN ROLE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 14),

                              TextField(
                                controller: roleController,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  hintText: "Enter role",
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.65),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.45),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 27,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF287D80).withOpacity(0.55),
                              width: 1.8,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF287D80),
                                size: 25,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      height: 1.25,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                        "New members will receive an invite\nto join the ",
                                      ),
                                      TextSpan(
                                        text: "STEMFlow",
                                        style: TextStyle(
                                          color: Color(0xFF287D80),
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " workspace via\nemail.",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: copyCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF287D80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              "Copy Code",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 4;
    const dashSpace = 4;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(20),
    );

    final path = Path()..addRRect(rRect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}