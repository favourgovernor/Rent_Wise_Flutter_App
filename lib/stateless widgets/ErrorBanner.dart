import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorBanner extends StatelessWidget {
  final int attempts;
  final int maxAttempts;

  const ErrorBanner(
      {super.key, required this.attempts, required this.maxAttempts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.danger?.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        // ignore: deprecated_member_use
        border: Border.all(color: _C.danger!.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: _C.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Invalid number. Attempt $attempts/$maxAttempts — after $maxAttempts failed attempts, your account will be locked.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _C.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _C {
  static Color? get danger => null;
}
