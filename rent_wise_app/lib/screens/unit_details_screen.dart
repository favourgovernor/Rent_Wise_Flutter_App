import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/ApartmentTabs.dart';
import '../stateless widgets/Header.dart';

class UnitDetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> units;
  final int initialIndex;

  const UnitDetailsScreen({
    super.key,
    required this.units,
    this.initialIndex = 0,
  });

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {
  int selectedTabIndex = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Scroll to the tapped unit after first frame renders
    if (widget.initialIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Approximate card height + margin
        const double cardHeight = 180.0;
        _scrollController.animateTo(
          widget.initialIndex * cardHeight,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: Header(),
      body: Column(
        children: [
          ApartmentTabs(
            tabs: const ['Apartment 1', 'Apartment 2', 'Apartment 3'],
            selectedIndex: selectedTabIndex,
            onTabSelected: (index) => setState(() => selectedTabIndex = index),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.units.length,
              itemBuilder: (context, index) {
                return UnitDetailCard(
                  unit: widget.units[index],
                  isHighlighted: index == widget.initialIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Unit Detail Card ─────────────────────────────────────────────────────────
class UnitDetailCard extends StatelessWidget {
  final Map<String, dynamic> unit;
  final bool isHighlighted;

  const UnitDetailCard({
    super.key,
    required this.unit,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = unit['status'] == 'Occupied';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: const Color(0xFF3DBE6E), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row ──────────────────────────────────────────────────────
          Row(
            children: [
              Text(
                unit['block'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                unit['floor'],
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '|',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isOccupied ? const Color(0xFF3DBE6E) : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unit['status'],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.delete_outline,
                color: Colors.red.shade300,
                size: 22,
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),

          // ── Name ─────────────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Name : ',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: unit['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // ── Rent Amount ───────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Rent Amount : ',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: unit['rent'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // ── Maintenance Requests ──────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Maintenance Requests :\n',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: unit['maintenance'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
