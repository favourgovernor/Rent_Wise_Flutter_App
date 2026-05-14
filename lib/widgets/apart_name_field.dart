import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

/// A single apartment rename row: numbered badge + text field.
class ApartNameField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ApartNameField({
    super.key,
    required this.index,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Number badge ──
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: RentWiseColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // ── Name field ──
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            style: GoogleFonts.poppins(
                fontSize: 13, color: RentWiseColors.textDark),
            decoration: InputDecoration(
              hintText: 'Apartment ${index + 1}',
              hintStyle: GoogleFonts.poppins(
                  fontSize: 13, color: RentWiseColors.textLight),
              prefixIcon: const Icon(Icons.apartment_outlined,
                  color: RentWiseColors.textMid, size: 16),
              filled: true,
              fillColor: RentWiseColors.inputFill,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: RentWiseColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: RentWiseColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: RentWiseColors.accent, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
