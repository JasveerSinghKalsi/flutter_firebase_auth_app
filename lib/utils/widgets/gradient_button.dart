import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final List<Color> gradientColors;
  final String text;
  final VoidCallback onPressed;
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    Gradient colorGradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: colorGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 55),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
