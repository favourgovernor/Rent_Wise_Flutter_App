import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TenantCard extends StatelessWidget {
  final String unitNumber;
  final String status;
  final String name;
  final String phone;
  final VoidCallback onMoreDetails;

  const TenantCard({
    super.key,
    required this.unitNumber,
    required this.status,
    required this.name,
    required this.phone,
    required this.onMoreDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                unitNumber,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'Unpaid'
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: status == 'Unpaid'
                        ? Colors.red.shade800
                        : Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Name: $name',
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Phone No.: $phone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onMoreDetails,
              child: Text(
                'more details →',
                style: GoogleFonts.poppins(
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
