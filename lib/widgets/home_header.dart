import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/widgets/rentwise_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
      child: Row(
        children: [
          Text('RentWise',
              style: GoogleFonts.pacifico(
                  fontSize: 26,
                  color: RentWiseColors.teal,
                  letterSpacing: 0.5)),
          const Spacer(),
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: RentWiseColors.textDark, size: 24),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: RentWiseColors.danger, shape: BoxShape.circle)),
            ),
          ]),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: RentWiseColors.teal, width: 2.5),
                color: RentWiseColors.primary,
              ),
              child: Center(
                child: Text('JK',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
