import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

class RoleSelector extends StatelessWidget {
  final List<String> roles;
  final String selected;
  final ValueChanged<String> onChanged;

  const RoleSelector({
    super.key,
    required this.roles,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: roles.map((r) {
        final on = r == selected;
        return GestureDetector(
          onTap: () => onChanged(r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: on ? RentWiseColors.primary : RentWiseColors.inputFill,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: on ? RentWiseColors.primary : RentWiseColors.border,
              ),
              boxShadow: on
                  ? [
                      BoxShadow(
                        color: RentWiseColors.primary.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              r,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: on ? Colors.white : RentWiseColors.textMid,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
