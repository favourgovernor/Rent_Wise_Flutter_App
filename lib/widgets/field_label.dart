import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

/// Small label rendered above every form field.
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: RentWiseColors.textMid,
      ),
    );
  }
}
