import 'package:flutter/material.dart';
//import 'package:rentwise_app/stateless%20widgets/BottomNav.dart';
import 'package:rentwise_app/stateless%20widgets/FinancialItem.dart';
import 'package:rentwise_app/stateless%20widgets/Header.dart';
import 'package:rentwise_app/stateless%20widgets/ApartmentTabs.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  int _selectedApartment = 0;
  //int _selectedTab = 3; // Revenue tab active by default

  static const _items = [
    FinancialItem(
      title: 'Rent Received',
      received: 4000,
      total: 5500,
      subtitle: 'Rent due this month',
    ),
    FinancialItem(
      title: 'Deposits',
      received: 4000,
      total: 5500,
      subtitle: 'Total deposits held',
      showTotal: false,
    ),
    FinancialItem(
      title: 'Water Bill',
      received: 4000,
      total: 5500,
      subtitle: 'Rent due this month',
    ),
    FinancialItem(
      title: 'Electricity Bill',
      received: 4000,
      total: 5500,
      subtitle: 'Rent due this month',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: Column(
          children: [
            // ── Your existing widgets ──────────────────────────
            Header(), // header.dart
            ApartmentTabs(
              // apartment_tabs.dart
              tabs: const ['Apartment 1', 'Apartment 2', 'Apartment 3'],
              selectedIndex: _selectedApartment,
              onTabSelected: (i) => setState(() => _selectedApartment = i),
            ),

            // ── Financial cards list ──────────────────────────
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _items.length,
                itemBuilder: (context, index) =>
                    FinancialCard(item: _items[index]),
              ),
            ),

            // ── Bottom navigation ─────────────────────────────
          ],
        ),
      ),
    );
  }
}
