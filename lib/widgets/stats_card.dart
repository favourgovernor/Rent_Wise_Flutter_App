import 'package:flutter/material.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';
import '../stateless widgets/HomeScreen Stateless Widget/stat_bar.dart';

class StatsCard extends StatelessWidget {
  final AppBuilding building;
  final Animation<double> animation;
  final String Function(double) formatCurrencyK;

  const StatsCard({
    super.key,
    required this.building,
    required this.animation,
    required this.formatCurrencyK,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        decoration: BoxDecoration(
          color: RentWiseColors.tealCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: RentWiseColors.teal.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Occupancy / Beds bar ──────────────
            StatBar(
              building.isHostel ? 'Beds' : 'Occupancy',
              building.isHostel
                  ? '${(building.occupancyRate * 100).round()}%  '
                      '(${building.occupiedBeds}/${building.totalBeds} beds)'
                  : '${(building.occupancyRate * 100).round()}%  '
                      '(${building.occupiedUnits}/${building.totalUnits})',
              building.occupancyRate * animation.value,
              color: RentWiseColors.accentMid,
            ),
            const SizedBox(height: 10),

            // ── Revenue bar ───────────────────────
            StatBar(
              'Revenue',
              '${(building.revenueRate * 100).round()}%  '
                  '(${formatCurrencyK(building.totalRevenue)})',
              building.revenueRate * animation.value,
              color: RentWiseColors.tealDark,
            ),
          ],
        ),
      ),
    );
  }
}
