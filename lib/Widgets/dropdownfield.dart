import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String value; // selected value
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
        color: const Color(0xff287D80).withOpacity(0.4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withOpacity(0.85),
          ),
          dropdownColor: const Color(0xff287D80), // dropdown bg
          borderRadius: BorderRadius.circular(14),
          style: TextStyle(
            color: Colors.white.withOpacity(0.90),
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: "Mynor",
            fontStyle: FontStyle.italic,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Mynor",
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}