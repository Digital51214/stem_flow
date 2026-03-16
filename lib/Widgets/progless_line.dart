import 'package:flutter/material.dart';
class ProgressLine extends StatelessWidget {
  final bool active;
  const ProgressLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: active
            ? const Color(0xFF56DCD6)
            : Colors.white.withOpacity(0.55),
      ),
    );
  }
}
