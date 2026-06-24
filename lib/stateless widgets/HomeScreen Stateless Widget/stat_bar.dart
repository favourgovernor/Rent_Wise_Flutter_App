import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

/// Horizontal progress bar with a label pill on the left
/// and text overlaid on the filled portion.
/// Used for Occupancy and Revenue bars in the stats card.
///
/// Usage:
///   StatBar('Occupancy', '70%  (7/10)', 0.7, color: RentWiseColors.accentMid)
class StatBar extends StatelessWidget {
  /// Short label shown in the white pill on the left.
  final String label;

  /// Text displayed centred over the bar, e.g. "70%  (7/10)".
  final String display;

  /// Fill fraction — 0.0 to 1.0.
  final double value;

  /// Colour of the gradient fill. Defaults to accent green.
  final Color color;

  const StatBar(
    this.label,
    this.display,
    this.value, {
    super.key,
    this.color = RentWiseColors.accentMid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Label pill ──────────────────────────
        Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: RentWiseColors.border),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: RentWiseColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 10),

        // ── Progress bar ────────────────────────
        Expanded(
          child: Stack(
            children: [
              // Background track
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: RentWiseColors.border),
                ),
              ),
              // Gradient fill
              FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.5), color],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Overlay text
              Positioned.fill(
                child: Center(
                  child: Text(
                    display,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: RentWiseColors.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
