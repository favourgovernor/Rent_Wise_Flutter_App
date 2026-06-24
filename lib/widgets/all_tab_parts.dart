import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/stat_tile.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class HostelOverviewGrid extends StatelessWidget {
  final AppBuilding building;
  final String Function(double) formatCurrencyK;

  const HostelOverviewGrid({
    super.key,
    required this.building,
    required this.formatCurrencyK,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        StatTile(
            icon: Icons.hotel_rounded,
            label: 'Total Rooms',
            value: '${building.totalUnits}',
            sub: '${building.partialUnits} partial',
            color: RentWiseColors.hostelColor),
        StatTile(
            icon: Icons.bed_rounded,
            label: 'Total Beds',
            value: '${building.totalBeds}',
            sub: '${building.availableBeds} available',
            color: RentWiseColors.tealDark),
        StatTile(
            icon: Icons.people_alt_rounded,
            label: 'Tenants',
            value: '${building.tenants.length}',
            sub: '${building.occupiedBeds} in beds',
            color: RentWiseColors.primary),
        StatTile(
            icon: Icons.monetization_on_rounded,
            label: 'Revenue',
            value: formatCurrencyK(building.totalRevenue),
            sub: 'of ${formatCurrencyK(building.expectedRevenue)}',
            color: RentWiseColors.warning),
      ],
    );
  }
}

class ApartmentOverviewGrid extends StatelessWidget {
  final AppBuilding building;
  final String Function(double) formatCurrencyK;

  const ApartmentOverviewGrid({
    super.key,
    required this.building,
    required this.formatCurrencyK,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.7,
      children: [
        StatTile(
            icon: Icons.meeting_room_rounded,
            label: 'Total Units',
            value: '${building.totalUnits}',
            sub: '${building.vacantUnits} vacant',
            color: RentWiseColors.teal),
        StatTile(
            icon: Icons.people_alt_rounded,
            label: 'Tenants',
            value: '${building.tenants.length}',
            sub: '${building.occupiedUnits} occupied',
            color: RentWiseColors.primary),
        StatTile(
            icon: Icons.check_circle_rounded,
            label: 'Paid',
            value:
                '${building.tenants.where((t) => t.status == 'paid').length}',
            sub: 'of ${building.tenants.length}',
            color: RentWiseColors.accent),
        StatTile(
            icon: Icons.monetization_on_rounded,
            label: 'Revenue',
            value: formatCurrencyK(building.totalRevenue),
            sub: 'of ${formatCurrencyK(building.expectedRevenue)}',
            color: RentWiseColors.warning),
      ],
    );
  }
}
