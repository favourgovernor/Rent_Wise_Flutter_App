import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rentwise_colors.dart';

/// 4-bar animated password strength indicator with Swahili label.
class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  int get _strength {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  String get _label {
    switch (_strength) {
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Color get _color {
    switch (_strength) {
      case 1:
        return const Color(0xFFD32F2F);
      case 2:
        return const Color(0xFFF57C00);
      case 3:
        return const Color(0xFF1976D2);
      case 4:
        return const Color(0xFF2E7D32);
      default:
        return RentWiseColors.border;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < _strength ? _color : RentWiseColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        if (_label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'password strength: $_label',
            style: GoogleFonts.poppins(fontSize: 11, color: _color),
          ),
        ],
      ],
    );
  }
}
