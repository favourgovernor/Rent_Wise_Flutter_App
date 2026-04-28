import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/ApartmentTabs.dart';
import '../stateless widgets/Header.dart';
import 'add_unit_screen.dart';
import 'unit_details_screen.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> allUnits = [];

  void _onUnitAdded(Map<String, dynamic> newUnit) {
    setState(() {
      allUnits.add(newUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: Header(),
      body: Column(
        children: [
          ApartmentTabs(
            tabs: const ['Apartment 1', 'Apartment 2', 'Apartment 3'],
            selectedIndex: selectedIndex,
            onTabSelected: (index) => setState(() => selectedIndex = index),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Text(
              'Units Details',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          Expanded(
            child: allUnits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No units yet',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap "ADD UNIT" to get started',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddUnitScreen(
                                  onUnitAdded: _onUnitAdded,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: Text(
                            'ADD UNIT',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3DBE6E),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: allUnits.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return AddUnitCard(
                          onAdd: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddUnitScreen(
                                  onUnitAdded: _onUnitAdded,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      final unit = allUnits[index - 1];

                      return UnitCard(
                        unitName: unit['block'],
                        status: unit['status'],
                        onMoreDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UnitDetailsScreen(
                                units: allUnits,
                                initialIndex: index - 1,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Add Unit Card ────────────────────────────────────────────────────────────
class AddUnitCard extends StatelessWidget {
  final VoidCallback onAdd;
  const AddUnitCard({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFB2EBF2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.add, size: 36, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onAdd,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black87, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'ADD UNIT  →',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Unit Card ────────────────────────────────────────────────────────────────
class UnitCard extends StatelessWidget {
  final String unitName;
  final String status;
  final VoidCallback onMoreDetails;

  const UnitCard({
    super.key,
    required this.unitName,
    required this.status,
    required this.onMoreDetails,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = status == 'Occupied';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isOccupied
                ? const Color(0xFF3DBE6E) // green
                : Colors.red, // red for Vacancy
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              unitName,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: onMoreDetails,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black26, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'more details →',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
