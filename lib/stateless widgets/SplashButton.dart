import 'package:flutter/material.dart';

class SplashButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const SplashButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? const Color(0xFF0E2233) : const Color(0xFF1A3A5C),
          foregroundColor: isPrimary ? Colors.white : const Color(0xFFB0CFE0),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isPrimary ? 17 : 15,
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
            letterSpacing: isPrimary ? 1.2 : 0.5,
          ),
        ),
      ),
    );
  }
}
