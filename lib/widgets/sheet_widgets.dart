import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

// ═══════════════════════════════════════════════
//  SHEET WRAPPER
// ═══════════════════════════════════════════════

/// White rounded bottom sheet container with a drag handle
/// and a coloured icon + title header.
class AppSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  const AppSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: RentWiseColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Title row
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 21),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: RentWiseColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            child,
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  SHEET LABEL
// ═══════════════════════════════════════════════

/// Small grey label used above fields inside bottom sheets.
class SheetLabel extends StatelessWidget {
  final String text;

  const SheetLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: RentWiseColors.textMid,
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  SHEET TEXT FIELD
// ═══════════════════════════════════════════════

/// Styled text field used inside bottom sheets.
class SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const SheetField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: GoogleFonts.poppins(fontSize: 14, color: RentWiseColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(fontSize: 13, color: RentWiseColors.textLight),
        prefixIcon: Icon(icon, color: RentWiseColors.textMid, size: 18),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RentWiseColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RentWiseColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: RentWiseColors.teal, width: 1.8),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  SHEET BUTTON
// ═══════════════════════════════════════════════

/// Full-width primary action button used at the bottom of sheets.
class SheetBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool disabled;
  final VoidCallback onTap;

  const SheetBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: disabled ? null : onTap,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: RentWiseColors.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
