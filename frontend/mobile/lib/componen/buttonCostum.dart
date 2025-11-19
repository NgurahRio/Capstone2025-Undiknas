import 'package:flutter/material.dart';

class ButtonCostum extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? height;

  const ButtonCostum({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF8AC4FA),
        foregroundColor: Colors.white,
        minimumSize: Size(
          double.infinity, 
          height ?? 60,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
