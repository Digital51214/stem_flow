import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stemflow/Authonticator_screens/Login_screen.dart';
import 'package:stemflow/Onboarding_screens/Onboarding_screen_page1.dart';
import 'package:stemflow/Onboarding_screens/Onboarding_screen_page2.dart';
import 'package:stemflow/Onboarding_screens/Onboarding_screen_page3.dart';

class MainOnboardingScreen extends StatefulWidget {
  const MainOnboardingScreen({super.key});

  @override
  State<MainOnboardingScreen> createState() => _MainOnboardingScreenState();
}

class _MainOnboardingScreenState extends State<MainOnboardingScreen>
    with SingleTickerProviderStateMixin {

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentProgress = 0.25;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation = Tween<double>(begin: 0.25, end: 0.25)
        .animate(_animationController)
      ..addListener(() {
        setState(() {
          _currentProgress = _animation.value;
        });
      });
  }

  double getProgressFromIndex(int index) {
    if (index == 0) return 0.25;
    if (index == 1) return 0.50;
    return 0.75;
  }

  void animateToPage(int newIndex) {
    double newProgress = getProgressFromIndex(newIndex);

    _animation = Tween<double>(
      begin: _currentProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          _currentProgress = _animation.value;
        });
      });

    _animationController.forward(from: 0);
  }

  void _nextPage() {
    if (_currentIndex < 2) {
      int nextIndex = _currentIndex + 1;
      animateToPage(nextIndex);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _currentIndex = nextIndex;
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Build ke andar MediaQuery — safe & correct
    final mq = MediaQuery.of(context);
    final double screenHeight = mq.size.height;
    final double screenWidth = mq.size.width;
    final double bottomPadding = mq.padding.bottom;

    // ✅ Responsive button size
    final double progressSize = screenWidth * 0.18;
    final double innerSize = progressSize * 0.94;
    final double iconSize = progressSize * 0.42;

    // ✅ Button position — screen height ka % + safe area
    final double bottomPosition = screenHeight * 0.045 + bottomPadding;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/BG 2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [

            // ✅ PageView full screen
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _currentIndex = index;
                animateToPage(index);
              },
              children: const [
                OnboardingPageOne(),
                OnboardingPagetwo(),
                OnboardingPagethree(),
              ],
            ),

            // ✅ Next button — responsive position
            Positioned(
              bottom: bottomPosition*2,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _nextPage,
                  child: SizedBox(
                    height: progressSize,
                    width: progressSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [

                        // Outer border circle
                        Container(
                          height: progressSize,
                          width: progressSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 2,
                            ),
                          ),
                        ),

                        // Progress arc
                        CustomPaint(
                          size: Size(progressSize, progressSize),
                          painter: GradientProgressPainter(_currentProgress),
                        ),

                        // Inner button
                        Container(
                          height: innerSize,
                          width: innerSize,
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff287D80),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff287D80),
                            ),
                            child: Center(
                              child: Image(
                                image: const AssetImage(
                                    "assets/images/Vector (1).png"),
                                height: iconSize,
                                width: iconSize,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class GradientProgressPainter extends CustomPainter {
  final double progress;

  GradientProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF287D80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // ✅ 2*pi = full circle, progress se animate hoga sahi
    final double sweepAngle = 2.8 * pi * progress;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GradientProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}