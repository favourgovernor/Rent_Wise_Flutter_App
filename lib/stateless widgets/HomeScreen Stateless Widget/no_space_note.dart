import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class NoSpaceNote extends StatelessWidget {
  final bool isHostel;

  const NoSpaceNote({super.key, required this.isHostel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RentWiseColors.warningLite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            isHostel ? Icons.hotel_outlined : Icons.meeting_room_outlined,
            color: RentWiseColors.warning,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            'No ${isHostel ? 'rooms' : 'units'} available',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: RentWiseColors.warning,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'All ${isHostel ? 'rooms' : 'units'} are fully occupied',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: RentWiseColors.textMid,
            ),
          ),
        ],
      ),
    );
  }
}
