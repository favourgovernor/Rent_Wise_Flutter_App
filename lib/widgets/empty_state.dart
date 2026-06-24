import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        const Icon(Icons.home_work_outlined,
            size: 64, color: RentWiseColors.textLight),
        const SizedBox(height: 20),
        Text('No Properties Yet',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: RentWiseColors.textDark)),
        const SizedBox(height: 10),
        Text(
          'You have not registered any properties.\nSign up or log in to get started.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 14, color: RentWiseColors.textMid, height: 1.6),
        ),
      ],
    );
  }
}
