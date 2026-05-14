import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

/// Live preview of the ApartmentTabs bar inside the signup form.
/// Mirrors the exact style of your ApartmentTabs widget so landlords
/// see the real UI before they finish signing up.
class ApartmentTabsPreview extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ApartmentTabsPreview({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scrollable tab row — same decoration as ApartmentTabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () => onTabSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? RentWiseColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: selected
                          ? RentWiseColors.primary
                          : const Color(0xFFCCCCCC),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : const Color(0xFF333333),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Showing: ${tabs[selectedIndex]}',
          style:
              GoogleFonts.poppins(fontSize: 11, color: RentWiseColors.textMid),
        ),
      ],
    );
  }
}
