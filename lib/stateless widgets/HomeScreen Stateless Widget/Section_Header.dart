import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const SectionHeader(
    this.title, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? RentWiseColors.textDark,
        letterSpacing: -0.3,
      ),
    );
  }
}
