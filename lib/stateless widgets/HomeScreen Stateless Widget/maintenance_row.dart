import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';
import '../../providers/property_provider.dart';

class MaintenanceRow extends StatelessWidget {
  final AppMaintenance item;
  final String Function(double) fmtFull;

  const MaintenanceRow({
    super.key,
    required this.item,
    required this.fmtFull,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RentWiseColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.type == 'invoice'
                  ? RentWiseColors.warningLite
                  : RentWiseColors.accentLite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.type == 'invoice'
                  ? Icons.receipt_long_rounded
                  : Icons.check_circle_outline_rounded,
              color: item.type == 'invoice'
                  ? RentWiseColors.warning
                  : RentWiseColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: RentWiseColors.textDark,
                  ),
                ),
                Text(
                  '${item.unitName} • ${_formatDate(item.date)}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: RentWiseColors.textMid,
                  ),
                ),
              ],
            ),
          ),
          Text(
            fmtFull(item.amount),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: item.type == 'invoice'
                  ? RentWiseColors.warning
                  : RentWiseColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
