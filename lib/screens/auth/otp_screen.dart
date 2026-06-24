// lib/screens/auth/otp_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for FilteringTextInputFormatter
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_widgets.dart';

// ════════════════════════════════════════════
//  OTP SCREEN
//
//  Arguments (passed via Navigator):
//    Map<String, dynamic> {
//      'email':    String  — the address the code was sent to
//      'name':     String  — landlord name (signup only)
//      'password': String  — password (signup only, for re-login)
//      'isLogin':  bool    — false = signup flow, true = login
//    }
//
//  On success:
//    isLogin = false → creates landlord profile → /setup
//    isLogin = true  → /home  (or /setup if incomplete)
// ════════════════════════════════════════════
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  // 6 separate controllers + focus nodes
  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _fNodes = List.generate(6, (_) => FocusNode());

  bool _verifying = false;
  bool _resending = false;
  bool _success = false;
  String? _error;
  int _cooldown = 60; // start at 60 so resend is locked initially
  Timer? _timer;

  // Arguments
  late String _email;
  late String _name;
  late String _phone;
  // ignore: unused_field
  late String _password;
  late bool _isLogin;

  // Shake animation for wrong code
  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    // Start the initial 60-second resend cooldown
    _startCooldown();

    // Focus first box after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fNodes[0].requestFocus();
    });

    // Rebuild when any focus node changes so box
    // colour updates live
    for (final fn in _fNodes) {
      fn.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Read route args here — safe to call multiple times
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _email = args?['email'] as String? ?? '';
    _name = args?['name'] as String? ?? '';
    _phone = args?['phone'] as String? ?? '';
    _password = args?['password'] as String? ?? '';
    _isLogin = args?['isLogin'] as bool? ?? false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeCtrl.dispose();
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _fNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ── Full OTP string ───────────────────────
  String get _otp => _ctrls.map((c) => c.text).join();

  // ── Handle typing in a box ────────────────
  void _onChanged(int idx, String val) {
    // ── Backspace: empty string received ────
    if (val.isEmpty) {
      _ctrls[idx].clear();
      if (idx > 0) {
        _ctrls[idx - 1].clear();
        _fNodes[idx - 1].requestFocus();
      }
      setState(() {});
      return;
    }

    // ── Paste: user pasted all 6 digits ─────
    if (val.length == 6) {
      for (int i = 0; i < 6; i++) {
        _ctrls[i].text = val[i];
        _ctrls[i].selection = TextSelection.collapsed(offset: 1);
      }
      _fNodes[5].requestFocus();
      _verify();
      return;
    }

    // ── Normal single digit typed ────────────
    // Keep only the last character typed
    if (val.length > 1) {
      _ctrls[idx].text = val[val.length - 1];
      _ctrls[idx].selection = const TextSelection.collapsed(offset: 1);
    }

    if (idx < 5) {
      _fNodes[idx + 1].requestFocus();
    }

    // Refresh box colours and auto-verify
    setState(() {});
    if (_otp.length == 6 && !_verifying) {
      _verify();
    }
  }

  // ── Handle backspace via onChanged ───────
  // We detect backspace by checking if an empty
  // string is received — this is more reliable
  // than RawKeyboardListener on Android 10 budget
  // devices and does not cause process crashes.

  // ── Verify the code ───────────────────────
  Future<void> _verify() async {
    if (_verifying || _success) return;
    final code = _otp;
    if (code.length < 6) {
      setState(() => _error = 'Please enter all 6 digits.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _verifying = true;
      _error = null;
    });

    try {
      // Verify with Supabase.
      // We use OtpType.email for signup flow
      // and OtpType.magiclink for login OTP flow.
      // signInWithOtp sends a magiclink-type OTP.
      final res = await Supabase.instance.client.auth.verifyOTP(
        email: _email,
        token: code,
        type: _isLogin ? OtpType.magiclink : OtpType.magiclink,
      );

      if (!mounted) return;

      if (res.user == null) {
        throw const AuthException('Verification failed.');
      }

      // Create/update the landlord profile
      if (!_isLogin) {
        await _ensureProfile(res.user!.id);
      }

      if (!mounted) return;

      // Show success tick briefly, then navigate
      setState(() {
        _verifying = false;
        _success = true;
      });
      await Future.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        _isLogin ? '/home' : '/setup',
        arguments: {
          'phone': _phone,
          'name': _name,
        },
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      // Clear boxes and shake
      for (final c in _ctrls) {
        c.clear();
      }
      _fNodes[0].requestFocus();
      _shakeCtrl.reset();
      _shakeCtrl.forward();

      setState(() {
        _verifying = false;
        _error = (e.message.toLowerCase().contains('invalid') ||
                e.message.toLowerCase().contains('expired') ||
                e.message.toLowerCase().contains('otp'))
            ? 'Invalid or expired code. Please try again.'
            : e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _verifying = false;
        _error = 'Verification failed. Please try again.';
      });
      debugPrint('OTP verify error: $e');
    }
  }

  // ── Create landlord profile ───────────────
  Future<void> _ensureProfile(String authId) async {
    // Generate short code
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    var seed = DateTime.now().millisecondsSinceEpoch;
    var code = '';
    for (int i = 0; i < 4; i++) {
      code += chars[seed % chars.length];
      seed ~/= chars.length;
    }

    try {
      final existing = await Supabase.instance.client
          .from('landlords')
          .select('id')
          .eq('auth_id', authId)
          .maybeSingle();

      if (existing != null) {
        // Row created by DB trigger — just update name
        if (_name.isNotEmpty) {
          await Supabase.instance.client
              .from('landlords')
              .update({'name': _name}).eq('auth_id', authId);
        }
      } else {
        // Create manually
        await Supabase.instance.client.from('landlords').insert({
          'auth_id': authId,
          'name': _name,
          'email': _email,
          'short_code': 'LND-$code',
          'role': 'Landlord',
          'is_complete': false,
        });
      }
    } catch (e) {
      debugPrint('Profile ensure error: $e');
      // Not fatal — user can still proceed to setup
    }
  }

  // ── Resend OTP ────────────────────────────
  Future<void> _resend() async {
    if (_cooldown > 0 || _resending) return;
    setState(() {
      _resending = true;
      _error = null;
    });

    try {
      // Resend using signInWithOtp — most reliable method
      await Supabase.instance.client.auth.signInWithOtp(
        email: _email,
        shouldCreateUser: false,
      );
      if (!mounted) return;
      _showSnack('New code sent to $_email');
      _startCooldown();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Could not resend. Please try again.');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _startCooldown() {
    setState(() => _cooldown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _cooldown--;
        if (_cooldown <= 0) t.cancel();
      });
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2233),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Dark header ──────────────────
          AuthHeader(
            title: 'Verify Your Email',
            subtitle: 'Enter the 6-digit code sent to\n$_email',
          ),

          // ── White scrollable card ────────
          AuthCard(
            child: Column(
              children: [
                // Email icon or success tick
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _success
                      ? Container(
                          key: const ValueKey('tick'),
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8F5E9),
                          ),
                          child: const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF2E7D32), size: 40),
                        )
                      : Container(
                          key: const ValueKey('email'),
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00BFA5).withOpacity(0.12),
                          ),
                          child: const Icon(Icons.mark_email_unread_rounded,
                              color: Color(0xFF00897B), size: 36),
                        ),
                ),
                const SizedBox(height: 16),

                Text(
                  _success ? 'Email Verified!' : 'Enter Verification Code',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0E2233)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: const Color(0xFF64748B)),
                    children: [
                      const TextSpan(text: 'Code sent to '),
                      TextSpan(
                        text: _email,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0E2233)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── 6 OTP boxes with shake ──
                AnimatedBuilder(
                  animation: _shakeCtrl,
                  builder: (_, child) {
                    final v = _shakeCtrl.value;
                    final dx = v < 0.5 ? -12 * v * 2 : 12 * (v - 0.5) * 2;
                    return Transform.translate(
                        offset: Offset(dx, 0), child: child);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) {
                      // Gap between box 3 and 4
                      return i == 3
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text('–',
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: const Color(0xFFBBC5D4))),
                                ),
                                _OtpBox(
                                  ctrl: _ctrls[i],
                                  fn: _fNodes[i],
                                  focused: _fNodes[i].hasFocus,
                                  hasError: _error != null,
                                  onChange: (v) => _onChanged(i, v),
                                ),
                              ],
                            )
                          : _OtpBox(
                              ctrl: _ctrls[i],
                              fn: _fNodes[i],
                              focused: _fNodes[i].hasFocus,
                              hasError: _error != null,
                              onChange: (v) => _onChanged(i, v),
                            );
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Error ──────────────────
                if (_error != null) ...[
                  AuthError(_error!),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 8),

                // ── Verify button ──────────
                AuthButton(
                  label: _success ? '✓ Verified' : 'Verify Code',
                  loading: _verifying,
                  onTap: _verify,
                ),
                const SizedBox(height: 20),

                // ── Resend ─────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Didn't receive it?  ",
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFF64748B))),
                    GestureDetector(
                      onTap: (_cooldown > 0 || _resending) ? null : _resend,
                      child: _resending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  color: Color(0xFF00897B), strokeWidth: 2))
                          : Text(
                              _cooldown > 0
                                  ? 'Resend in ${_cooldown}s'
                                  : 'Resend',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _cooldown > 0
                                      ? const Color(0xFFBBC5D4)
                                      : const Color(0xFF00897B)),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Spam note ──────────────
                const AuthInfo(
                  "Can't find the code? Check your Spam or "
                  "Junk folder. It may take up to 2 minutes.",
                ),
                const SizedBox(height: 16),

                // ── Back link ──────────────
                GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: Text('← Back to Sign In',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: const Color(0xFF9CA3AF),
                          decoration: TextDecoration.underline)),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single OTP digit box ──────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController ctrl;
  final FocusNode fn;
  final bool focused;
  final bool hasError;
  final ValueChanged<String> onChange;
  const _OtpBox({
    required this.ctrl,
    required this.fn,
    required this.focused,
    required this.hasError,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color fillColor;

    if (hasError) {
      borderColor = const Color(0xFFD32F2F);
      fillColor = const Color(0xFFFFEBEE);
    } else if (focused) {
      borderColor = const Color(0xFF00BFA5);
      fillColor = const Color(0xFFE0F7FA);
    } else if (ctrl.text.isNotEmpty) {
      borderColor = const Color(0xFF0E2233);
      fillColor = const Color(0xFFE8F5E9);
    } else {
      borderColor = const Color(0xFFE5E7EB);
      fillColor = Colors.white;
    }

    return SizedBox(
      width: 44,
      height: 54,
      child: TextField(
        controller: ctrl,
        focusNode: fn,
        onChanged: onChange,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0E2233)),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: fillColor,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.8)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF00BFA5), width: 2.2)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
