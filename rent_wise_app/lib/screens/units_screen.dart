import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentwise_app/stateless%20widgets/ApartmentTabs.dart';
import '../stateless widgets/Header.dart';
import 'add_unit_screen.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  final List<String> unitBlocks = [
    'B1',
    'B2',
    'B3',
    'B4',
    'B5',
    'B6',
    'B7',
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: Header(),
      body: Column(
        children: [
          ApartmentTabs(
            tabs: const [
              'Apartment 1',
              'Apartment 2',
              'Apartment 3'
            ], // Replace with actual tab list
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          // Header
          Container(
            padding: EdgeInsets.all(16),
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

          // Units Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: unitBlocks.length,
              itemBuilder: (context, index) {
                return UnitCard(
                  unitName: unitBlocks[index],
                  onAdd: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddUnitScreen()),
                    );
                  },
                  onMoreDetails: () {
                    // Navigate to unit details
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

class UnitCard extends StatelessWidget {
  final String unitName;
  final VoidCallback onAdd;
  final VoidCallback onMoreDetails;

  const UnitCard({
    super.key,
    required this.unitName,
    required this.onAdd,
    required this.onMoreDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unitName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: onAdd,
                child: Text(
                  'Add Unit',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: onMoreDetails,
                child: Text(
                  'more details →',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
