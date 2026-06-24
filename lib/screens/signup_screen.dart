// lib/screens/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/screens/auth/auth_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();

  // Focus nodes — one per field, in tab order
  final _nameFN = FocusNode();
  final _emailFN = FocusNode();
  final _phoneFN = FocusNode();
  final _passFN = FocusNode();
  final _cpassFN = FocusNode();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _cpassCtrl = TextEditingController();

  bool _hidePass = true;
  bool _hideCPass = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameFN.dispose();
    _emailFN.dispose();
    _phoneFN.dispose();
    _passFN.dispose();
    _cpassFN.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _cpassCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  SUBMIT
  //
  //  1. signUp()       — creates the account
  //  2. signInWithOtp  — sends the 6-digit code
  //
  //  Phone number is passed to OTP screen args
  //  so SetupScreen can pre-fill it.
  // ─────────────────────────────────────────
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final phone = _phoneCtrl.text.trim();
      final password = _passCtrl.text;

      // Step 1 — Create the Supabase account
      try {
        await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': name,
            'phone': phone,
          },
        );
      } on AuthException catch (e) {
        // Account already exists — still send OTP below
        if (!e.message.toLowerCase().contains('already registered') &&
            !e.message.toLowerCase().contains('already exists')) {
          rethrow;
        }
      }

      if (!mounted) return;

      // Step 2 — Send 6-digit OTP via signInWithOtp
      // This is reliable regardless of dashboard settings
      await Supabase.instance.client.auth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );

      if (!mounted) return;
      setState(() => _loading = false);

      // Navigate to OTP screen — pass all details
      Navigator.pushReplacementNamed(
        context,
        '/otp',
        arguments: {
          'email': email,
          'name': name,
          'phone': phone, // ← passed so SetupScreen can pre-fill
          'password': password,
          'isLogin': false,
        },
      );
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
      debugPrint('Signup error: $e');
    }
  }

  String _friendly(String raw) {
    final m = raw.toLowerCase();
    if (m.contains('already registered') || m.contains('already exists')) {
      return 'An account with this email already exists.\nPlease sign in instead.';
    }
    if (m.contains('weak') || m.contains('password')) {
      return 'Password must be at least 6 characters.';
    }
    if (m.contains('email')) {
      return 'Please enter a valid email address.';
    }
    return raw;
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
          const AuthHeader(
            title: 'Create Account',
            subtitle: 'Sign up and start managing\nyour properties',
          ),

          // ── White scrollable form ────────
          AuthCard(
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Full name ────────────
                  const AuthLabel('Full Name'),
                  AuthField(
                    controller: _nameCtrl,
                    focusNode: _nameFN,
                    hint: 'e.g. John Kamau',
                    icon: Icons.person_outline_rounded,
                    action: TextInputAction.next,
                    onNext: () => FocusScope.of(context).requestFocus(_emailFN),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Full name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Email ────────────────
                  const AuthLabel('Email Address'),
                  AuthField(
                    controller: _emailCtrl,
                    focusNode: _emailFN,
                    hint: 'you@example.com',
                    icon: Icons.email_outlined,
                    keyboard: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    onNext: () => FocusScope.of(context).requestFocus(_phoneFN),
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

                  // ── Phone number ─────────
                  const AuthLabel('Phone Number'),
                  AuthField(
                    controller: _phoneCtrl,
                    focusNode: _phoneFN,
                    hint: '07XX XXX XXX',
                    icon: Icons.phone_outlined,
                    keyboard: TextInputType.phone,
                    action: TextInputAction.next,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onNext: () => FocusScope.of(context).requestFocus(_passFN),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (v.trim().length < 9) {
                        return 'Enter a valid Kenyan phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Divider ──────────────
                  Row(children: [
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Security',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500)),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ]),
                  const SizedBox(height: 16),

                  // ── Password ─────────────
                  const AuthLabel('Password'),
                  AuthPasswordField(
                    controller: _passCtrl,
                    focusNode: _passFN,
                    hint: 'Minimum 6 characters',
                    obscure: _hidePass,
                    onToggle: () => setState(() => _hidePass = !_hidePass),
                    action: TextInputAction.next,
                    onNext: () => FocusScope.of(context).requestFocus(_cpassFN),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Password is required';
                      }
                      if (v.length < 6) {
                        return 'At least 6 characters required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Confirm password ─────
                  const AuthLabel('Confirm Password'),
                  AuthPasswordField(
                    controller: _cpassCtrl,
                    focusNode: _cpassFN,
                    hint: 'Re-enter your password',
                    obscure: _hideCPass,
                    onToggle: () => setState(() => _hideCPass = !_hideCPass),
                    action: TextInputAction.done,
                    onNext: _submit,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (v != _passCtrl.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── OTP info note ─────────
                  const AuthInfo(
                    'A 6-digit verification code will be '
                    'sent to your email after you tap '
                    'Create Account.',
                  ),
                  const SizedBox(height: 20),

                  // ── Error ─────────────────
                  if (_error != null) ...[
                    AuthError(_error!),
                    const SizedBox(height: 16),
                  ],

                  // ── Submit button ─────────
                  AuthButton(
                    label: 'Create Account',
                    loading: _loading,
                    onTap: _submit,
                  ),
                  const SizedBox(height: 20),

                  // ── Sign in link ──────────
                  AuthBottomLink(
                    question: 'Already have an account?',
                    action: 'Sign In',
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
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
