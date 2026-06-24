import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class BuildingTabs extends StatelessWidget {
  final List<AppBuilding> buildings;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddBuilding;

  const BuildingTabs({
    super.key,
    required this.buildings,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onAddBuilding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: buildings.length + 1,
        itemBuilder: (context, index) {
          if (index == buildings.length) {
            return _buildAddButton();
          }
          return _buildBuildingTab(index);
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddBuilding,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: RentWiseColors.teal.withOpacity(0.5)),
        ),
        child: Row(children: [
          Icon(Icons.add_rounded, color: RentWiseColors.teal, size: 16),
          const SizedBox(width: 4),
          Text('Add',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: RentWiseColors.teal)),
        ]),
      ),
    );
  }

  Widget _buildBuildingTab(int index) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? RentWiseColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: isSelected
                  ? RentWiseColors.primary
                  : const Color(0xFFCCCCCC)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: RentWiseColors.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Text(
          buildings[index].name,
          style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF333333)),
        ),
      ),
    );
  }
}
