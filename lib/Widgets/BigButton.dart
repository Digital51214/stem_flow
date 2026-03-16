import 'package:flutter/material.dart';
class BigButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const BigButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF287D80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            fontFamily: "Mynor",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
