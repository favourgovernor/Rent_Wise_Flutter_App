import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/rentwise_colors.dart';

// ════════════════════════════════════════════════════
//  VERIFY EMAIL SCREEN
//
//  Shown after a landlord registers with email.
//  Supabase sends them a confirmation link.
//
//  This screen:
//   1. Shows the email address they signed up with
//   2. Listens for the Supabase auth state change
//      that fires when they click the link
//   3. Auto-navigates to /signup once verified
//   4. Lets them resend if they didn't receive it
//
//  Navigation: Pass email via route arguments
//    Navigator.pushReplacementNamed(
//      context, '/verify-email',
//      arguments: 'user@example.com',
//    );
// ════════════════════════════════════════════════════
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with TickerProviderStateMixin {
  // ── Auth state listener ───────────────────────
  late StreamSubscription<AuthState> _authSubscription;

  // ── Resend cooldown ───────────────────────────
  int _resendCooldown = 0;
  Timer? _cooldownTimer;
  bool _isSending = false;
  bool _verified = false;

  // ── Animation ────────────────────────────────
  late AnimationController _checkCtrl;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _checkScale = CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);

    // Listen for auth state change.
    // When the landlord clicks the email link,
    // Supabase fires signedIn with the new session.
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;
      if (data.event == AuthChangeEvent.signedIn && data.session != null) {
        setState(() => _verified = true);
        _checkCtrl.forward();
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/signup');
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _cooldownTimer?.cancel();
    _checkCtrl.dispose();
    super.dispose();
  }

  // ── Resend verification email ─────────────────
  Future<void> _resendEmail(String email) async {
    if (_resendCooldown > 0 || _isSending) return;
    setState(() => _isSending = true);
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: 'io.supabase.rentwise://login-callback',
      );
      if (!mounted) return;
      _showSnack('Verification email resent to $email');
      _startCooldown();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Could not resend. Please try again.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _startCooldown() {
    setState(() => _resendCooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) t.cancel();
      });
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: RentWiseColors.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final email =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'your email';

    return Scaffold(
      backgroundColor: RentWiseColors.bg,
      // Keeps layout stable when keyboard appears
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          // ── FIX: SingleChildScrollView replaces the
          // rigid Column so content never overflows.
          // The 28px overflow was caused by Padding +
          // Column having no way to scroll on smaller
          // screens.
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── Icon / animated checkmark ────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _verified
                    ? ScaleTransition(
                        key: const ValueKey('check'),
                        scale: _checkScale,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: RentWiseColors.accentLite,
                          ),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: RentWiseColors.accent,
                            size: 52,
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey('email'),
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: RentWiseColors.teal.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_rounded,
                          color: RentWiseColors.teal,
                          size: 44,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // ── Headline ──────────────────────
              Text(
                _verified ? 'Email Verified! ✅' : 'Check Your Email',
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: RentWiseColors.textDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Text(
                _verified
                    ? 'Your email has been confirmed.\nSetting up your account...'
                    : 'We sent a verification link to:',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: RentWiseColors.textMid, height: 1.5),
                textAlign: TextAlign.center,
              ),

              if (!_verified) ...[
                const SizedBox(height: 8),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: RentWiseColors.primary),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 24),

              if (!_verified) ...[
                // ── Steps card ───────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RentWiseColors.border),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What to do next:',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: RentWiseColors.textDark)),
                      const SizedBox(height: 14),
                      _Step(
                          number: '1',
                          text: 'Open your email app '
                              '(Gmail, Outlook etc.)'),
                      const SizedBox(height: 10),
                      _Step(
                          number: '2',
                          text: 'Look for an email from '
                              'RentWise — subject: '
                              '"Confirm your email"'),
                      const SizedBox(height: 10),
                      _Step(
                          number: '3',
                          text: 'Tap the '
                              '"Confirm your email" '
                              'link inside'),
                      const SizedBox(height: 10),
                      _Step(
                          number: '4',
                          text: 'This screen updates '
                              'automatically once '
                              'confirmed'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Spam warning ─────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RentWiseColors.warningLite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: RentWiseColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.info_outline_rounded,
                        color: RentWiseColors.warning, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Can't find the email? "
                        'Check your Spam or Junk folder.',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: RentWiseColors.warning,
                            height: 1.4),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // ── Resend button ────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: (_resendCooldown > 0 || _isSending)
                        ? null
                        : () => _resendEmail(email),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: RentWiseColors.teal, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      foregroundColor: RentWiseColors.teal,
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: RentWiseColors.teal, strokeWidth: 2))
                        : Text(
                            _resendCooldown > 0
                                ? 'Resend in ${_resendCooldown}s'
                                : 'Resend Verification Email',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _resendCooldown > 0
                                  ? RentWiseColors.textLight
                                  : RentWiseColors.teal,
                            )),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Back to login ────────────────
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Back to Sign In',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: RentWiseColors.textMid,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                // Extra bottom padding so content
                // never sits flush against the edge
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
//  NUMBERED STEP ROW
// ════════════════════════════════════════════════════
class _Step extends StatelessWidget {
  final String number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: RentWiseColors.primary,
          ),
          child: Center(
            child: Text(number,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: RentWiseColors.textMid, height: 1.4)),
        ),
      ],
    );
  }
}
