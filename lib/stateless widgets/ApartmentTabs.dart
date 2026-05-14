import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApartmentTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const ApartmentTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final selected = i == selectedIndex;
            return GestureDetector(
              onTap: () => onTabSelected(i),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF0E2233) : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF0E2233)
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
    );
  }
}
