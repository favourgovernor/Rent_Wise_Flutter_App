import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityFooter extends StatelessWidget {
  const SecurityFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_rounded, size: 11, color: _C.textLight),
        const SizedBox(width: 5),
        Text(
          'Protected by TLS 1.3 · Encrypted data',
          style: GoogleFonts.poppins(fontSize: 10, color: _C.textLight),
        ),
      ],
    );
  }
}

class _C {
  static Color? get textLight => null;
}
