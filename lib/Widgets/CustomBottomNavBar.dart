import 'package:flutter/material.dart';

final ValueNotifier<int> selectedPageNotifier = ValueNotifier<int>(0);

class ImageLikeBottomNavBar extends StatelessWidget {
  const ImageLikeBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, _) {
        return BottomAppBar(
          color: const Color(0xFF1E7F7A),
          shape: const CircularNotchedRectangle(),
          notchMargin: mq.height * 0.013,
          child: SizedBox(
            height: mq.height * 0.075 + bottomPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding-34),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavImage(
                    imagePath: "assets/images/home.png",
                    label: "Home",
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      selectedPageNotifier.value = 0;
                    },
                  ),

                  _NavImage(
                    imagePath: "assets/images/task.png",
                    label: "Tasks",
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      selectedPageNotifier.value = 1;
                    },
                  ),

                  SizedBox(width: mq.width * 0.13),

                  _NavImage(
                    imagePath: "assets/images/cube.png",
                    label: "Projects",
                    isSelected: selectedIndex == 3,
                    onTap: () {
                      selectedPageNotifier.value = 3;
                    },
                  ),

                  _NavImage(
                    imagePath: "assets/images/more.png",
                    label: "More",
                    isSelected: selectedIndex == 4,
                    onTap: () {
                      selectedPageNotifier.value = 4;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CenterAiButton extends StatelessWidget {
  const CenterAiButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, _) {
        final bool isSelected = selectedIndex == 2;

        return FloatingActionButton(
          elevation: mq.width * 0.012,
          backgroundColor: const Color(0xFF1E7F7A),
          shape: const CircleBorder(),
          onPressed: () {
            selectedPageNotifier.value = 2;
          },
          child: Image.asset("assets/images/map.png"
              ,width: mq.width * 0.07,),
        );
      },
    );
  }
}

class _NavImage extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavImage({
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(mq.width * 0.03),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: mq.height * 0.006),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: mq.width * 0.058,
              height: mq.width * 0.058,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            SizedBox(height: mq.height * 0.003),
            Text(
              label,
              style: TextStyle(
                fontSize: mq.width * 0.024,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontFamily: "Mynor",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}