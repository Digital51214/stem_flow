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
                  const _NavIcon(icon: Icons.home, label: "Home"),
                  const _NavIcon(icon: Icons.description_outlined, label: "Tasks"),
                  // ✅ Calendar item with fixed size so circle stays big
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Icon(
                        Icons.calendar_month,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const _NavIcon(icon: Icons.map_outlined, label: "Phases"),
                  const _NavIcon(icon: Icons.person_outline, label: "More"),
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

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: Colors.white),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontFamily: "Mynor",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}