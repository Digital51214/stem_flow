import 'package:flutter/material.dart';
class Bg2 extends StatelessWidget {
  final Widget child;
  const Bg2({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}