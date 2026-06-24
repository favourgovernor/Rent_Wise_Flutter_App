import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityBadge extends StatelessWidget {
  final int failedAttempts;
  const SecurityBadge({super.key, required this.failedAttempts});

  @override
  Widget build(BuildContext context) {
    final bool warn = failedAttempts >= 3;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: warn ? _C.warning.withOpacity(0.08) : _C.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: warn ? _C.warning.withOpacity(0.3) : _C.teal.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            warn ? Icons.warning_amber_rounded : Icons.verified_user_rounded,
            color: warn ? _C.warning : _C.teal,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              warn
                  ? 'Warning: Attempts $failedAttempts/5 have failed.'
                  : 'This account is protected by advanced encryption.',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: warn ? _C.warning : _C.tealDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _C {
  static const Color warning = Color(0xFFFFA000);
  static const Color teal = Color(0xFF009688);
  static const Color tealDark = Color(0xFF00695C);
}
