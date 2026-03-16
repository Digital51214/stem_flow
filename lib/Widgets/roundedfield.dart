import 'package:flutter/material.dart';
class RoundedField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final double height;

  const RoundedField({
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.55), width: 1.2),
        color: Colors.white.withOpacity(0.08),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white, fontSize: 14,
          fontFamily: "Mynor",),
        cursorColor: const Color(0xFF6FE6E4),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: "Mynor",
          ),
        ),
      ),
    );
  }
}