import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatRow extends StatelessWidget {
  final String label;
  final double value; // 0.0 – 1.0

  const StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).toInt();
    return Row(
      children: [
        // Label pill
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFCCCCCC)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // Progress bar
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFCCCCCC)),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Green gradient fill
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF56D463), Color(0xFF1A7A2E)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                  ),
                ),
                // Percentage label
                Center(
                  child: Text(
                    '$pct%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
