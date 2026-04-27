import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/tenant_card.dart';
import 'tenant_details_screen.dart';
import '../stateless widgets/Header.dart';
import '../stateless widgets/ApartmentTabs.dart';

class TenantsScreen extends StatefulWidget {
  const TenantsScreen({super.key});

  @override
  _TenantsScreenState createState() => _TenantsScreenState();
}

class _TenantsScreenState extends State<TenantsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  final List<String> _tabs = ['ADD', 'VIEW'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 👉 REMOVE if not created yet OR import properly
            Header(),
            ApartmentTabs(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onTabSelected: (i) => setState(() => _selectedTab = i),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue.shade900,
              labelColor: Colors.blue.shade900,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'ADD'),
                Tab(text: 'VIEW'),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ================= ADD TAB =================
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tenant Details',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Name'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Email',
                          keyboard: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Phone Number',
                          keyboard: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Room No.'),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Add Tenant'),
                        ),
                      ],
                    ),
                  ),

                  // ================= VIEW TAB =================
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TenantCard(
                        unitNumber: 'R/M: 200',
                        status: 'Unpaid',
                        name: 'Favour Governor',
                        phone: '0797 208 371',
                        onMoreDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TenantDetailsScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TenantCard(
                        unitNumber: 'R/M: 200',
                        status: 'Paid',
                        name: 'Favour Governor',
                        phone: '0797 208 371',
                        onMoreDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TenantDetailsScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TenantCard(
                        unitNumber: 'R/M: 201',
                        status: 'Unpaid',
                        name: 'Sophia Patel',
                        phone: '0797 208 371',
                        onMoreDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TenantDetailsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REUSABLE FIELD =================
  Widget _buildTextField(String label,
      {TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
