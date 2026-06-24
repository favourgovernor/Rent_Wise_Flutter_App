import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityLockDialog extends StatelessWidget {
  final VoidCallback onUnlock;
  const SecurityLockDialog({super.key, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _C.danger.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_rounded, color: _C.danger, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              'Account closed for security reasons',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _C.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have attempted to log in 5 times without success. For your safety, the account has been locked temporarily.\n\nPlease check your phone for a message to unlock your account, or contact support.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: _C.textMid,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onUnlock();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'I need help',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _C {
  static const Color danger = Color(0xFFDC2626);

  static Color? get primary => null;

  static Color? get textMid => null;

  static Color? get textDark => null;
}
