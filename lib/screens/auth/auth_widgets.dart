// lib/screens/auth/auth_widgets.dart
//
// Shared UI pieces used across all auth screens.
// Import this single file in every auth screen.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
//  DARK HEADER  (top navy section)
// ─────────────────────────────────────────────
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // SafeArea top padding so header clears the status bar
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      color: const Color(0xFF0E2233),
      padding: EdgeInsets.fromLTRB(28, top + 20, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo row
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.home_work_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text('RentWise',
                style: GoogleFonts.pacifico(
                    fontSize: 20, color: const Color(0xFF00BFA5))),
          ]),
          const SizedBox(height: 20),
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.white54, height: 1.4)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  AUTH CARD  (white scrollable body)
// ─────────────────────────────────────────────
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF7F9FC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: SingleChildScrollView(
            // Bottom padding accounts for keyboard AND nav bar
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 28,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  24,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FIELD LABEL
// ─────────────────────────────────────────────
class AuthLabel extends StatelessWidget {
  final String text;
  const AuthLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151))),
      );
}

// ─────────────────────────────────────────────
//  TEXT FIELD  (standard)
// ─────────────────────────────────────────────
class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final IconData icon;
  final TextInputType keyboard;
  final TextInputAction action;
  final VoidCallback onNext;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> formatters;

  const AuthField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.icon,
    this.keyboard = TextInputType.text,
    this.action = TextInputAction.next,
    required this.onNext,
    this.validator,
    this.formatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboard,
      textInputAction: action,
      inputFormatters: formatters,
      onEditingComplete: onNext,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF0E2233)),
      decoration: _deco(hint, icon),
    );
  }
}

// ─────────────────────────────────────────────
//  PASSWORD FIELD
// ─────────────────────────────────────────────
class AuthPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final TextInputAction action;
  final VoidCallback onNext;
  final String? Function(String?)? validator;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.action = TextInputAction.done,
    required this.onNext,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      textInputAction: action,
      onEditingComplete: onNext,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF0E2233)),
      decoration: _deco(hint, Icons.lock_outlined,
          suffix: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: const Color(0xFF9CA3AF),
            ),
            onPressed: onToggle,
          )),
    );
  }
}

// ─────────────────────────────────────────────
//  PRIMARY BUTTON
// ─────────────────────────────────────────────
class AuthButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const AuthButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E2233),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF0E2233).withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ERROR BOX
// ─────────────────────────────────────────────
class AuthError extends StatelessWidget {
  final String message;
  const AuthError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD32F2F).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFD32F2F), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFFD32F2F), height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  INFO NOTE  (teal)
// ─────────────────────────────────────────────
class AuthInfo extends StatelessWidget {
  final String message;
  const AuthInfo(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF00897B), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: const Color(0xFF00695C), height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM LINK  ("Already have an account? Sign In")
// ─────────────────────────────────────────────
class AuthBottomLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$question  ',
            style: GoogleFonts.poppins(
                fontSize: 14, color: const Color(0xFF64748B))),
        GestureDetector(
          onTap: onTap,
          child: Text(action,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00897B))),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED INPUT DECORATION
// ─────────────────────────────────────────────
InputDecoration _deco(String hint, IconData icon, {Widget? suffix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle:
        GoogleFonts.poppins(fontSize: 14, color: const Color(0xFFBBC5D4)),
    prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 2)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2)),
    errorStyle: GoogleFonts.poppins(fontSize: 12),
  );
}
