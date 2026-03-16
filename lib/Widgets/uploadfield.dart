import 'package:flutter/material.dart';

class UploadField extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? selectedIcon;

  const UploadField({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: Colors.white.withOpacity(0.55), width: 1.2),
          color: Colors.white.withOpacity(0.08),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Left side: selected icon OR upload icon
            Icon(
              isSelected && selectedIcon != null ? selectedIcon : Icons.upload,
              color: isSelected
                  ? Colors.greenAccent
                  : const Color(0xFF1A7A79),
            ),
            const Spacer(),
            // Text: "Icon Uploaded ✓" when selected, else original text
            Text(
              isSelected ? "✓ Icon Uploaded" : text,
              style: TextStyle(
                color: isSelected
                    ? Colors.greenAccent
                    : const Color(0xFF1A7A79),
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: "Mynor",
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}