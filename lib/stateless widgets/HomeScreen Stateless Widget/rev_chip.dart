import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RevChip extends StatelessWidget {
  final String label;
  final double amount;
  final int count;
  final Color color;

  const RevChip(
    this.label,
    this.amount,
    this.count,
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'KES ${amount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            '$count tenant${count != 1 ? 's' : ''}',
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
