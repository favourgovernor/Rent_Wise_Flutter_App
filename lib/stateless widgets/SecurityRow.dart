import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const SecurityRow({
    required this.icon,
    required this.text,
    this.color = _C.tealDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: color,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _C {
  static const Color? tealDark = null;
}
