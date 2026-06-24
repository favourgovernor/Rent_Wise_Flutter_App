import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class TaxRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const TaxRow(
    this.label,
    this.value, {
    super.key,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted ? RentWiseColors.purpleLite : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: highlighted
            ? Border.all(color: RentWiseColors.purple.withOpacity(0.3))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: highlighted ? FontWeight.w600 : FontWeight.w400,
              color:
                  highlighted ? RentWiseColors.purple : RentWiseColors.textMid,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: highlighted ? FontWeight.w800 : FontWeight.w600,
              color:
                  highlighted ? RentWiseColors.purple : RentWiseColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
