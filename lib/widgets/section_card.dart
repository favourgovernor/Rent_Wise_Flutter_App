import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RentWiseColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: RentWiseColors.accentLite,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: RentWiseColors.accent, size: 17),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: RentWiseColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: RentWiseColors.border, height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
