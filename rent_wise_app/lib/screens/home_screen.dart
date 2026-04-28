import 'package:flutter/material.dart';
import 'package:rentwise_app/screens/RevenueScreen.dart';
import 'package:rentwise_app/screens/tenants_screen.dart';
import 'package:rentwise_app/screens/units_screen.dart';
import 'package:rentwise_app/stateless%20widgets/Header.dart';
import 'package:rentwise_app/stateless%20widgets/Stat_Row.dart';
import 'package:rentwise_app/stateless%20widgets/BottomNav.dart';
import 'package:rentwise_app/stateless%20widgets/ApartmentTabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    TenantsScreen(),
    UnitsScreen(),
    RevenueScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ── Home content ─────────────────────────────────────────────────────────────

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _selectedTab = 0;

  final List<String> _tabs = ['Apartment 1', 'Apartment 2', 'Apartment 3'];

  // Per-tab data (occupancy %, revenue %)
  final List<Map<String, double>> _tabData = [
    {'occupancy': 60.0, 'revenue': 0.60},
    {'occupancy': 80.0, 'revenue': 0.45},
    {'occupancy': 30.0, 'revenue': 0.75},
  ];

  @override
  Widget build(BuildContext context) {
    final data = _tabData[_selectedTab];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Header(),
          const SizedBox(height: 15),
          // ── Tab row ──────────────────────────────────────────────
          ApartmentTabs(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onTabSelected: (i) => setState(() => _selectedTab = i),
          ),
          const SizedBox(height: 16),

          // ── Stats card ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD6F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  StatRow(label: 'Occupancy', value: data['occupancy']! / 100),
                  SizedBox(height: 20),
                  StatRow(label: 'Revenue', value: data['revenue']! / 100),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
