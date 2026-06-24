import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class UnitCard extends StatelessWidget {
  final AppUnit unit;
  final List<AppTenant> tenants;

  const UnitCard({
    super.key,
    required this.unit,
    required this.tenants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RentWiseColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    unit.isHostel
                        ? Icons.hotel_rounded
                        : Icons.meeting_room_rounded,
                    color: RentWiseColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    unit.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: RentWiseColors.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: unit.isFull
                      ? RentWiseColors.dangerLite
                      : RentWiseColors.accentLite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unit.isFull ? 'Full' : '${unit.availableBeds} beds left',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: unit.isFull
                        ? RentWiseColors.danger
                        : RentWiseColors.accent,
                  ),
                ),
              ),
            ],
          ),
          if (unit.isHostel) ...[
            const SizedBox(height: 8),
            Text(
              '${tenants.length}/${unit.capacity} tenants • KES ${unit.rentPerBed.toStringAsFixed(0)}/bed',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: RentWiseColors.textMid,
              ),
            ),
            if (tenants.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...tenants.map((t) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: RentWiseColors.accentLite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              t.name.substring(0, 1).toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: RentWiseColors.accent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            t.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: RentWiseColors.textDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.status == 'paid'
                                ? RentWiseColors.accentLite
                                : t.status == 'pending'
                                    ? RentWiseColors.warningLite
                                    : RentWiseColors.dangerLite,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t.status,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: t.status == 'paid'
                                  ? RentWiseColors.accent
                                  : t.status == 'pending'
                                      ? RentWiseColors.warning
                                      : RentWiseColors.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ] else ...[
            const SizedBox(height: 8),
            if (tenants.isNotEmpty)
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: RentWiseColors.accentLite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        tenants.first.name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: RentWiseColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenants.first.name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: RentWiseColors.textDark,
                          ),
                        ),
                        Text(
                          'Rent: KES ${unit.rentTotal.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: RentWiseColors.textMid,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tenants.first.status == 'paid'
                          ? RentWiseColors.accentLite
                          : tenants.first.status == 'pending'
                              ? RentWiseColors.warningLite
                              : RentWiseColors.dangerLite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tenants.first.status,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: tenants.first.status == 'paid'
                            ? RentWiseColors.accent
                            : tenants.first.status == 'pending'
                                ? RentWiseColors.warning
                                : RentWiseColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
