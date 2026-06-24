// lib/screens/auth/login_screen.dart
//
// LOGIN SCREEN
// Fields: Email + Password + Phone (optional for now)
// On success → loads landlord data → HomeScreen
// Never shows property setup — that is signup only.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rentwise_app/screens/auth/auth_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/property_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailFN = FocusNode();
  final _phoneFN = FocusNode();
  final _passFN = FocusNode();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _hidePass = true;
  bool _loading = false;
  bool _showPhone = false; // toggle phone field visibility
  String? _error;

  @override
  void dispose() {
    _emailFN.dispose();
    _phoneFN.dispose();
    _passFN.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Sign in ────────────────────────────────────
  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Step 1 — authenticate with email + password
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) return;
      if (res.user == null) {
        throw const AuthException('Sign in failed.');
      }

      // Step 2 — load landlord data from Supabase
      // (buildings, units, tenants etc.)
      await context.read<PropertyProvider>().loadFromSupabase();
      if (!mounted) return;

      // Step 3 — always go to HomeScreen
      // The landlord sees their properties immediately.
      // Setup screen is ONLY for first-time signup.
      Navigator.pushReplacementNamed(context, '/home');
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _friendly(e.message);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Something went wrong. Please try again.';
      });
      debugPrint('Login error: $e');
    }
  }

  // ── Forgot password ────────────────────────────
  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() =>
          _error = 'Type your email above first, then tap Forgot Password.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack('Password reset link sent to $email');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showSnack('Could not send reset email. Try again.');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
      backgroundColor: const Color(0xFF2E7D32),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ));
  }

  String _friendly(String raw) {
    final m = raw.toLowerCase();
    if (m.contains('invalid login credentials') ||
        m.contains('invalid credentials') ||
        m.contains('wrong') ||
        m.contains('incorrect')) {
      return 'Incorrect email or password. Please try again.';
    }
    if (m.contains('email not confirmed')) {
      return 'Your email is not verified yet. '
          'Check your inbox for a verification code.';
    }
    if (m.contains('too many')) {
      return 'Too many attempts. Please wait a moment.';
    }
    if (m.contains('user not found') || m.contains('no user')) {
      return 'No account found with this email. Please sign up.';
    }
    return raw;
  }

  // ── Build ──────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2233),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Dark header ────────────────────────
          const AuthHeader(
            title: 'Welcome Back 👋',
            subtitle: 'Sign in to manage your\nproperties and tenants',
          ),

          // ── White scrollable form ──────────────
          AuthCard(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Email ──────────────────────
                  const AuthLabel('Email Address'),
                  AuthField(
                    controller: _emailCtrl,
                    focusNode: _emailFN,
                    hint: 'you@example.com',
                    icon: Icons.email_outlined,
                    keyboard: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    onNext: () => _showPhone
                        ? FocusScope.of(context).requestFocus(_phoneFN)
                        : FocusScope.of(context).requestFocus(_passFN),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.\w{2,}$')
                          .hasMatch(v.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Phone (optional — toggle) ──
                  // Will become required when SMS OTP
                  // is integrated via Celcom Africa
                  GestureDetector(
                    onTap: () => setState(() => _showPhone = !_showPhone),
                    child: Row(children: [
                      Icon(
                        _showPhone
                            ? Icons.remove_circle_outline
                            : Icons.add_circle_outline,
                        size: 16,
                        color: const Color(0xFF00897B),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showPhone
                            ? 'Remove phone number'
                            : 'Add phone number (optional)',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF00897B),
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
                  ),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _showPhone
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AuthLabel('Phone Number'),
                                AuthField(
                                  controller: _phoneCtrl,
                                  focusNode: _phoneFN,
                                  hint: '07XX XXX XXX',
                                  icon: Icons.phone_outlined,
                                  keyboard: TextInputType.phone,
                                  formatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  action: TextInputAction.next,
                                  onNext: () => FocusScope.of(context)
                                      .requestFocus(_passFN),
                                  validator: (v) {
                                    if (!_showPhone) return null;
                                    if (v != null &&
                                        v.isNotEmpty &&
                                        v.trim().length < 9) {
                                      return 'Enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),

                  // ── Password ───────────────────
                  const AuthLabel('Password'),
                  AuthPasswordField(
                    controller: _passCtrl,
                    focusNode: _passFN,
                    hint: 'Your password',
                    obscure: _hidePass,
                    onToggle: () => setState(() => _hidePass = !_hidePass),
                    action: TextInputAction.done,
                    onNext: _signIn,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Password is required'
                        : null,
                  ),

                  // ── Forgot password ────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _loading ? null : _forgotPassword,
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8)),
                      child: Text('Forgot password?',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF00897B),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),

                  // ── Error ──────────────────────
                  if (_error != null) ...[
                    AuthError(_error!),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox(height: 4),

                  // ── Sign in button ─────────────
                  AuthButton(
                    label: 'Sign In',
                    loading: _loading,
                    onTap: _signIn,
                  ),
                  const SizedBox(height: 20),

                  // ── Divider ────────────────────
                  Row(children: [
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: const Color(0xFF9CA3AF))),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ]),
                  const SizedBox(height: 20),

                  // ── Sign up link ───────────────
                  AuthBottomLink(
                    question: 'No account yet?',
                    action: 'Create one',
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/signup'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
