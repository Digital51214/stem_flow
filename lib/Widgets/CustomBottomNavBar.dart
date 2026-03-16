import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);

class ImageLikeBottomNavBar extends StatelessWidget {
  const ImageLikeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, _) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CurvedNavigationBar(
                index: selectedIndex,
                height: 70,
                color: const Color(0xFF1E7F7A),
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: const Color(0xFF1E7F7A),
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                items: [
                  _NavImage(
                    imagePath: "assets/images/home.png",
                    label: "Home",
                    isSelected: selectedIndex == 0,
                  ),
                  _NavImage(
                    imagePath: "assets/images/tasks.png",
                    label: "Tasks",
                    isSelected: selectedIndex == 1,
                  ),

                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Image.asset(
                        "assets/images/calender.png",
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                        color: selectedIndex == 2
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                  ),

                  _NavImage(
                    imagePath: "assets/images/phases.png",
                    label: "Phases",
                    isSelected: selectedIndex == 3,
                  ),
                  _NavImage(
                    imagePath: "assets/images/more.png",
                    label: "More",
                    isSelected: selectedIndex == 4,
                  ),
                ],
                onTap: (index) {
                  selectedPageNotifier.value = index;
                },
              ),
              SizedBox(height: bottomPadding),
            ],
          ),
        );
      },
    );
  }
}

class _NavImage extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;

  const _NavImage({
    required this.imagePath,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          color: isSelected ? Colors.white : Colors.white,
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? Colors.white: Colors.white.withOpacity(0.5),
            fontFamily: "Mynor",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}