import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class BuildingTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const BuildingTypeChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if (!selected) return RentWiseColors.textMid;
      switch (label.toLowerCase()) {
        case 'apartment':
          return RentWiseColors.primary;
        case 'hostel':
          return RentWiseColors.hostelColor;
        case 'mixed':
          return RentWiseColors.purple;
        default:
          return RentWiseColors.primary;
      }
    }

    final color = getColor();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : RentWiseColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
} // TODO Implement this library.
