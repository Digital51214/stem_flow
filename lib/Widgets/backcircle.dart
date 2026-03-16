import 'package:flutter/material.dart';
class BackCircle extends StatelessWidget {
  final VoidCallback onTap;
  const BackCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 18),
      ),
    );
  }
}