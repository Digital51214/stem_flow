import 'package:flutter/material.dart';
class PillSmall extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const PillSmall({
    required this.text,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 39,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected
              ? const Color(0xFF287D80)
              : Colors.white.withOpacity(0.50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : Colors.black.withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: "Mynor",
                color: selected ? Colors.white : Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}