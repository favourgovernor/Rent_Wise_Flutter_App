import 'package:flutter/material.dart';

class _C {
  static const Color primary = Color(0xFF1A3C6E);
  static const Color accent = Color(0xFF2E7D32);
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.home_work_rounded, color: _C.primary, size: 28),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            children: [
              TextSpan(text: 'Rent', style: TextStyle(color: _C.primary)),
              TextSpan(text: 'Wise', style: TextStyle(color: _C.accent)),
            ],
          ),
        ),
      ],
    );
  }
}
