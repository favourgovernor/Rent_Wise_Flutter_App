import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/Section_Header.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/add_bar.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/count_chip.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/empty_card.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/unit_card.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class UnitsTab extends StatelessWidget {
  final AppBuilding building;
  final VoidCallback onAddUnit;

  const UnitsTab({
    super.key,
    required this.building,
    required this.onAddUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddBar(
          icon: building.isHostel
              ? Icons.hotel_rounded
              : Icons.meeting_room_rounded,
          label: building.isHostel ? 'Add Hostel Room' : 'Add Unit',
          color: building.isHostel
              ? RentWiseColors.hostelColor
              : RentWiseColors.tealDark,
          onTap: onAddUnit,
        ),
        const SizedBox(height: 24),
        _buildStatsChips(),
        const SizedBox(height: 16),
        SectionHeader(building.isHostel
            ? 'All Rooms  (${building.totalUnits})'
            : 'All Units  (${building.totalUnits})'),
        const SizedBox(height: 12),
        if (building.units.isEmpty)
          EmptyCard(
            icon: building.isHostel
                ? Icons.hotel_outlined
                : Icons.meeting_room_outlined,
            title: building.isHostel ? 'No Rooms Yet' : 'No Units Yet',
            sub:
                'Tap the button above to add your first ${building.isHostel ? 'room' : 'unit'}.',
            color: building.isHostel
                ? RentWiseColors.hostelColor
                : RentWiseColors.tealDark,
          )
        else
          ...building.units.map((u) => UnitCard(
                unit: u,
                tenants:
                    building.tenants.where((t) => t.unitId == u.id).toList(),
              )),
      ],
    );
  }

  Widget _buildStatsChips() {
    if (building.isHostel || building.isMixed) {
      return Wrap(spacing: 10, runSpacing: 8, children: [
        CountChip(
            icon: Icons.bed_rounded,
            label: 'Occupied Beds',
            count: building.occupiedBeds,
            color: RentWiseColors.accent),
        CountChip(
            icon: Icons.bed_outlined,
            label: 'Available Beds',
            count: building.availableBeds,
            color: RentWiseColors.warning),
      ]);
    } else {
      return Row(children: [
        CountChip(
            icon: Icons.home_rounded,
            label: 'Occupied',
            count: building.occupiedUnits,
            color: RentWiseColors.accent),
        const SizedBox(width: 10),
        CountChip(
            icon: Icons.lock_open_rounded,
            label: 'Vacant',
            count: building.vacantUnits,
            color: RentWiseColors.warning),
      ]);
    }
  }
}
