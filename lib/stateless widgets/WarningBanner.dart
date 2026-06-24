import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WarningBanner extends StatelessWidget {
  final String message;
  const WarningBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _C.danger.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _C.danger.withOpacity(0.25)),
      ),
      child: Text(
        message,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: _C.danger,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _C {
  static const Color danger = Color(0xFFD32F2F);
}
