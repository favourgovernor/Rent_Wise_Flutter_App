import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['ALL', 'Tenants', 'Units', 'Revenue'];
    const icons = [
      Icons.dashboard_rounded,
      Icons.people_alt_rounded,
      Icons.meeting_room_rounded,
      Icons.bar_chart_rounded,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -3))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 : 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (index == 0
                        ? RentWiseColors.teal
                        : RentWiseColors.primary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[index],
                      size: 18,
                      color:
                          isSelected ? Colors.white : RentWiseColors.textMid),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(labels[index],
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
