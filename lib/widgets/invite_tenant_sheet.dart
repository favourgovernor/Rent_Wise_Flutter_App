import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/app_sheet.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/no_space_note.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/sheet_btn.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/sheet_field.dart';
import 'package:rentwise_app/stateless%20widgets/HomeScreen%20Stateless%20Widget/sheet_label.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

void showInviteTenantSheet(
  BuildContext context, {
  required AppBuilding building,
  required List<String> Function(AppUnit) getAvailableBedLabels,
  required String Function(double) formatCurrencyK,
  required VoidCallback onInviteSent,
}) {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? selectedUnitId;
  String bedLabel = 'Bed A';

  final availableUnits = building.units.where((u) => !u.isFull).toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final selectedUnit = selectedUnitId != null
            ? availableUnits.firstWhere((u) => u.id == selectedUnitId,
                orElse: () => availableUnits.first)
            : null;

        // FIXED: Added explicit List<String> type annotation
        final List<String> availableBeds =
            selectedUnit != null && selectedUnit.isHostel
                ? getAvailableBedLabels(selectedUnit)
                : [];

        return AppSheet(
          title: 'Invite Tenant',
          icon: Icons.person_add_rounded,
          iconColor: RentWiseColors.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 20),
              const SheetLabel('Select Room (available beds shown)'),
              const SizedBox(height: 10),
              if (availableUnits.isEmpty)
                NoSpaceNote(isHostel: building.isHostel)
              else
                _buildUnitSelector(
                  availableUnits,
                  selectedUnitId,
                  formatCurrencyK,
                  (id) => setState(() {
                    selectedUnitId = id;
                    final selected =
                        availableUnits.firstWhere((u) => u.id == id);
                    final beds = getAvailableBedLabels(selected);
                    if (beds.isNotEmpty) bedLabel = beds.first;
                  }),
                ),
              if (selectedUnit != null &&
                  selectedUnit.isHostel &&
                  availableBeds.isNotEmpty)
                _buildBedSelector(availableBeds, bedLabel,
                    (label) => setState(() => bedLabel = label)),
              const SizedBox(height: 20),
              const SheetLabel('Tenant Phone Number'),
              const SizedBox(height: 8),
              SheetField(
                controller: phoneController,
                hint: '07XX XXX XXX',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 14),
              const SheetLabel('Tenant Email  (optional)'),
              const SizedBox(height: 8),
              SheetField(
                controller: emailController,
                hint: 'tenant@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 28),
              SheetBtn(
                label: 'Send Invite Link',
                icon: Icons.send_rounded,
                color: RentWiseColors.accent,
                disabled: availableUnits.isEmpty || selectedUnitId == null,
                onTap: () {
                  Navigator.pop(context);
                  onInviteSent();
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildInfoBanner() {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: RentWiseColors.accentLite,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: RentWiseColors.accent.withOpacity(0.2)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded,
            color: RentWiseColors.accent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'The tenant will receive a link to fill in their details and sign the lease digitally. Each tenant has their own record.',
            style: GoogleFonts.poppins(
                fontSize: 12, color: RentWiseColors.accent, height: 1.5),
          ),
        ),
      ],
    ),
  );
}

Widget _buildUnitSelector(
  List<AppUnit> units,
  String? selectedId,
  String Function(double) formatCurrencyK,
  Function(String) onSelect,
) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: units.map((unit) {
      final isSelected = unit.id == selectedId;
      return GestureDetector(
        onTap: () => onSelect(unit.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? RentWiseColors.accent : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
                color:
                    isSelected ? RentWiseColors.accent : RentWiseColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(unit.name,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : RentWiseColors.textDark)),
              if (unit.isHostel)
                Text(
                    '${unit.availableBeds} of ${unit.capacity} beds free  ·  ${formatCurrencyK(unit.rentPerBed)}/bed',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white70
                            : RentWiseColors.textMid))
              else
                Text('${formatCurrencyK(unit.rentTotal)}/mo',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white70
                            : RentWiseColors.textMid)),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildBedSelector(
  List<String> beds,
  String selectedBed,
  Function(String) onSelect,
) {
  return Column(
    children: [
      const SizedBox(height: 16),
      const SheetLabel('Assign Bed'),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: beds.map((bed) {
          final isSelected = bed == selectedBed;
          return GestureDetector(
            onTap: () => onSelect(bed),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? RentWiseColors.hostelColor : Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                    color: isSelected
                        ? RentWiseColors.hostelColor
                        : RentWiseColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bed_rounded,
                      size: 14,
                      color:
                          isSelected ? Colors.white : RentWiseColors.textMid),
                  const SizedBox(width: 6),
                  Text(bed,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : RentWiseColors.textMid)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ],
  );
}
