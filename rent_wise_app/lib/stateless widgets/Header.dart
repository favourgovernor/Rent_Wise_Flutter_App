import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RentWise',
            style: GoogleFonts.dancingScript(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3A7A96),
            ),
          ),
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFDDDDDD),
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=47',
            ),
          ),
        ],
      ),
    );
  }
}
