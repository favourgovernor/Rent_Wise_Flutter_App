import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final Color color;

  const EmptyCard({
    super.key,
    required this.icon,
    required this.title,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
