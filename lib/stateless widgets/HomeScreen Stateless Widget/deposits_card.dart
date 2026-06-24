import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class DepositsCard extends StatelessWidget {
  final List<AppTenant> tenants;
  final double total;
  final String Function(double) fmtFull;

  const DepositsCard({
    super.key,
    required this.tenants,
    required this.total,
    required this.fmtFull,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RentWiseColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Deposits Held',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: RentWiseColors.textDark,
                ),
              ),
              Text(
                fmtFull(total),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: RentWiseColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tenants.map((t) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
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
                    const SizedBox(width: 10),
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
                    Text(
                      fmtFull(t.deposit),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: RentWiseColors.textDark,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
