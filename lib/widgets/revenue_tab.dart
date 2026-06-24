import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/Section_Header.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/rev_chip.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/tenant_row.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class RevenueTab extends StatelessWidget {
  final AppBuilding building;
  final String Function(double) formatCurrencyFull;
  final Animation<double> animation;
  final VoidCallback onKraTax;
  final Color Function(String) getStatusColor;
  final Color Function(String) getStatusBackgroundColor;
  final IconData Function(String) getStatusIcon;
  final String Function(String) getStatusLabel;

  const RevenueTab({
    super.key,
    required this.building,
    required this.formatCurrencyFull,
    required this.animation,
    required this.onKraTax,
    required this.getStatusColor,
    required this.getStatusBackgroundColor,
    required this.getStatusIcon,
    required this.getStatusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final paid = building.tenants.where((t) => t.status == 'paid').toList();
    final pending =
        building.tenants.where((t) => t.status == 'pending').toList();
    final overdue =
        building.tenants.where((t) => t.status == 'overdue').toList();
    final paidAmount = paid.fold<double>(0, (s, t) => s + t.rent);
    final pendingAmount = pending.fold<double>(0, (s, t) => s + t.rent);
    final overdueAmount = overdue.fold<double>(0, (s, t) => s + t.rent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRevenueHeroCard(),
        const SizedBox(height: 20),
        _buildRevenueChips(paidAmount, paid.length, pendingAmount,
            pending.length, overdueAmount, overdue.length),
        const SizedBox(height: 28),
        _buildKraTaxCard(),
        const SizedBox(height: 28),
        if (overdue.isNotEmpty) _buildOverdueSection(overdue),
        if (pending.isNotEmpty) _buildPendingSection(pending),
      ],
    );
  }

  Widget _buildRevenueHeroCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF0E2233), Color(0xFF1A3C5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue This Month',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white60)),
          const SizedBox(height: 6),
          Text(
            formatCurrencyFull(building.totalRevenue),
            style: GoogleFonts.poppins(
                fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          Text('of ${formatCurrencyFull(building.expectedRevenue)} expected',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.white54)),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) => ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: building.revenueRate * animation.value,
                backgroundColor: Colors.white24,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(RentWiseColors.teal),
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChips(
      double paidAmount,
      int paidCount,
      double pendingAmount,
      int pendingCount,
      double overdueAmount,
      int overdueCount) {
    return Row(children: [
      Expanded(
          child: RevChip(
              'Received', paidAmount, paidCount, RentWiseColors.accent)),
      const SizedBox(width: 10),
      Expanded(
          child: RevChip(
              'Pending', pendingAmount, pendingCount, RentWiseColors.warning)),
      const SizedBox(width: 10),
      Expanded(
          child: RevChip(
              'Overdue', overdueAmount, overdueCount, RentWiseColors.danger)),
    ]);
  }

  Widget _buildKraTaxCard() {
    return GestureDetector(
      onTap: onKraTax,
      child: Container(
        decoration: BoxDecoration(
          color: RentWiseColors.purpleLite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RentWiseColors.purple.withOpacity(0.25)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: RentWiseColors.purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: RentWiseColors.purple, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KRA Tax Payment',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: RentWiseColors.purple)),
                Text(
                    'Est. ${formatCurrencyFull(building.expectedRevenue * 0.075)} (7.5% MRI)',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: RentWiseColors.textMid)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: RentWiseColors.purple),
        ]),
      ),
    );
  }

  Widget _buildOverdueSection(List<AppTenant> overdue) {
    return Column(
      children: [
        const SectionHeader('Overdue Payments', color: RentWiseColors.danger),
        const SizedBox(height: 12),
        ...overdue.map((t) => TenantRow(
              t,
              RentWiseColors.danger,
              RentWiseColors.dangerLite,
              Icons.error_rounded,
              'Overdue',
            )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPendingSection(List<AppTenant> pending) {
    return Column(
      children: [
        const SectionHeader('Pending Payments'),
        const SizedBox(height: 12),
        ...pending.map((t) => TenantRow(
              t,
              RentWiseColors.warning,
              RentWiseColors.warningLite,
              Icons.schedule_rounded,
              'Pending',
            )),
      ],
    );
  }
}
