import 'package:flutter/material.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/Section_Header.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/add_bar.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/empty_card.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/tenant_row.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class TenantsTab extends StatelessWidget {
  final AppBuilding building;
  final Color Function(String) getStatusColor;
  final Color Function(String) getStatusBackgroundColor;
  final IconData Function(String) getStatusIcon;
  final String Function(String) getStatusLabel;
  final VoidCallback onInviteTenant;

  const TenantsTab({
    super.key,
    required this.building,
    required this.getStatusColor,
    required this.getStatusBackgroundColor,
    required this.getStatusIcon,
    required this.getStatusLabel,
    required this.onInviteTenant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddBar(
          icon: Icons.person_add_rounded,
          label: 'Invite Tenant',
          color: RentWiseColors.accent,
          onTap: onInviteTenant,
        ),
        const SizedBox(height: 24),
        SectionHeader('Tenants  (${building.tenants.length})'),
        const SizedBox(height: 12),
        if (building.tenants.isEmpty)
          EmptyCard(
            icon: Icons.people_alt_outlined,
            title: 'No Tenants Yet',
            sub: 'Tap "Invite Tenant" to send a registration link.',
            color: RentWiseColors.accent,
          )
        else
          ...building.tenants.map((t) => TenantRow(
                t,
                getStatusColor(t.status),
                getStatusBackgroundColor(t.status),
                getStatusIcon(t.status),
                getStatusLabel(t.status),
              )),
      ],
    );
  }
}
