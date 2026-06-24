import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/Section_Header.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/available_banner.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/big_stat_card.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/deposits_card.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/empty_card.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/maintenance_row.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/quick_action.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/tenant_row.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';
import 'all_tab_parts.dart';

class AllTab extends StatelessWidget {
  final AppBuilding building;
  final String Function(double) formatCurrencyK;
  final String Function(double) formatCurrencyFull;
  final Color Function(String) getStatusColor;
  final Color Function(String) getStatusBackgroundColor;
  final IconData Function(String) getStatusIcon;
  final String Function(String) getStatusLabel;
  final VoidCallback onMessageTenants;
  final VoidCallback onInviteTenant;
  final VoidCallback onAddUnit;
  final VoidCallback onKraTax;
  final VoidCallback onAddMaintenance;

  const AllTab({
    super.key,
    required this.building,
    required this.formatCurrencyK,
    required this.formatCurrencyFull,
    required this.getStatusColor,
    required this.getStatusBackgroundColor,
    required this.getStatusIcon,
    required this.getStatusLabel,
    required this.onMessageTenants,
    required this.onInviteTenant,
    required this.onAddUnit,
    required this.onKraTax,
    required this.onAddMaintenance,
  });

  @override
  Widget build(BuildContext context) {
    final paid = building.tenants.where((t) => t.status == 'paid').length;
    final pending = building.tenants.where((t) => t.status == 'pending').length;
    final overdue = building.tenants.where((t) => t.status == 'overdue').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPropertyTypeBadge(),
        const SizedBox(height: 16),
        const SectionHeader('Quick Actions'),
        const SizedBox(height: 12),
        _buildQuickActions(),
        const SizedBox(height: 28),
        const SectionHeader('Overview'),
        const SizedBox(height: 12),
        building.isHostel
            ? HostelOverviewGrid(
                building: building, formatCurrencyK: formatCurrencyK)
            : ApartmentOverviewGrid(
                building: building, formatCurrencyK: formatCurrencyK),
        const SizedBox(height: 28),
        const SectionHeader('Payment Status'),
        const SizedBox(height: 12),
        _buildPaymentStatusCards(paid, pending, overdue),
        const SizedBox(height: 28),
        if (overdue > 0) _buildOverdueSection(overdue),
        const SectionHeader('Tenant Deposits'),
        const SizedBox(height: 12),
        DepositsCard(
          tenants: building.tenants,
          total: building.totalDeposits,
          fmtFull: formatCurrencyFull,
        ),
        const SizedBox(height: 28),
        _buildMaintenanceSection(),
        const SizedBox(height: 28),
        _buildAvailabilityBanner(),
      ],
    );
  }

  Widget _buildPropertyTypeBadge() {
    Color color;
    String label;
    IconData icon;

    switch (building.propertyType) {
      case PropertyType.hostel:
        color = RentWiseColors.hostelColor;
        label = 'Hostel';
        icon = Icons.hotel_rounded;
        break;
      case PropertyType.mixed:
        color = RentWiseColors.purple;
        label = 'Mixed';
        icon = Icons.villa_rounded;
        break;
      default:
        color = RentWiseColors.tealDark;
        label = 'Apartment';
        icon = Icons.apartment_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _buildQuickActions() {
    return Row(children: [
      Expanded(
          child: QuickAction(
        icon: Icons.chat_rounded,
        label: 'Message\nTenants',
        color: RentWiseColors.indigo,
        bg: RentWiseColors.indigoLite,
        onTap: onMessageTenants,
      )),
      const SizedBox(width: 10),
      Expanded(
          child: QuickAction(
        icon: Icons.person_add_rounded,
        label: 'Invite\nTenant',
        color: RentWiseColors.accent,
        bg: RentWiseColors.accentLite,
        onTap: onInviteTenant,
      )),
      const SizedBox(width: 10),
      Expanded(
          child: QuickAction(
        icon: building.isHostel
            ? Icons.hotel_rounded
            : Icons.meeting_room_rounded,
        label: building.isHostel ? 'Add\nRoom' : 'Add\nUnit',
        color: RentWiseColors.tealDark,
        bg: RentWiseColors.tealCard,
        onTap: onAddUnit,
      )),
      const SizedBox(width: 10),
      Expanded(
          child: QuickAction(
        icon: Icons.account_balance_rounded,
        label: 'Pay\nKRA Tax',
        color: RentWiseColors.purple,
        bg: RentWiseColors.purpleLite,
        onTap: onKraTax,
      )),
    ]);
  }

  Widget _buildPaymentStatusCards(int paid, int pending, int overdue) {
    return Row(children: [
      Expanded(
          child: BigStatCard(
              label: 'Paid',
              value: '$paid',
              color: RentWiseColors.accent,
              icon: Icons.check_circle_rounded)),
      const SizedBox(width: 10),
      Expanded(
          child: BigStatCard(
              label: 'Pending',
              value: '$pending',
              color: RentWiseColors.warning,
              icon: Icons.schedule_rounded)),
      const SizedBox(width: 10),
      Expanded(
          child: BigStatCard(
              label: 'Overdue',
              value: '$overdue',
              color: RentWiseColors.danger,
              icon: Icons.error_rounded)),
    ]);
  }

  Widget _buildOverdueSection(int overdue) {
    return Column(
      children: [
        const SectionHeader('⚠️  Needs Attention',
            color: RentWiseColors.danger),
        const SizedBox(height: 12),
        ...building.tenants
            .where((t) => t.status == 'overdue')
            .map((t) => TenantRow(
                  t,
                  getStatusColor(t.status),
                  getStatusBackgroundColor(t.status),
                  getStatusIcon(t.status),
                  getStatusLabel(t.status),
                )),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _buildMaintenanceSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader('Maintenance & Repairs'),
            GestureDetector(
              onTap: onAddMaintenance,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: RentWiseColors.warningLite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: RentWiseColors.warning.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.add_rounded,
                      color: RentWiseColors.warning, size: 14),
                  const SizedBox(width: 4),
                  Text('Add',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: RentWiseColors.warning)),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (building.maintenance.isEmpty)
          EmptyCard(
            icon: Icons.build_outlined,
            title: 'No Records Yet',
            sub: 'Tap "Add" to record invoices or receipts.',
            color: RentWiseColors.warning,
          )
        else
          ...building.maintenance
              .map((m) => MaintenanceRow(item: m, fmtFull: formatCurrencyFull)),
      ],
    );
  }

  Widget _buildAvailabilityBanner() {
    if (building.isHostel && building.availableBeds > 0) {
      return AvailableBanner(
        count: building.availableBeds,
        label:
            '${building.availableBeds} Bed${building.availableBeds > 1 ? 's' : ''} Available',
        sub: 'Some rooms have empty beds.',
        onAdd: onInviteTenant,
      );
    } else if (!building.isHostel && building.vacantUnits > 0) {
      return AvailableBanner(
        count: building.vacantUnits,
        label:
            '${building.vacantUnits} Unit${building.vacantUnits > 1 ? 's' : ''} Vacant',
        sub: 'Invite tenants to fill vacant units.',
        onAdd: onInviteTenant,
      );
    }
    return const SizedBox.shrink();
  }
}
