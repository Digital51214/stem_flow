import 'package:flutter/material.dart';
class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {

    final icons = [
      Icons.sports_soccer,
      Icons.sports_cricket,
      Icons.sports_basketball,
      Icons.sports_esports,
      Icons.groups,
      Icons.emoji_events,
      Icons.shield,
      Icons.flag,
      Icons.star,
      Icons.military_tech,
      Icons.sports_martial_arts,
      Icons.fitness_center,
    ];

    return Dialog(
      backgroundColor: const Color(0xff287D80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, icons[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Icon(
                  icons[index],
                  size: 30,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}