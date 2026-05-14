import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'RentWise',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Tenants'),
                Tab(text: 'Chats'),
                Tab(text: 'Requests'),
              ],
              indicatorColor: Colors.blue.shade900,
              labelColor: Colors.blue.shade900,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildMessageCard(
                  name: 'Favour Governor',
                  message: 'When will the maintenance be done?',
                  time: '10:30 AM',
                  unread: true,
                ),
                _buildMessageCard(
                  name: 'Sophia Patel',
                  message: 'Rent payment sent',
                  time: 'Yesterday',
                  unread: false,
                ),
                _buildMessageCard(
                  name: 'John Doe',
                  message: 'Thank you for your prompt response',
                  time: 'Yesterday',
                  unread: false,
                ),
                _buildMessageCard(
                  name: 'Water Bill',
                  message: 'Bill payment reminder: KSH 4,000',
                  time: '2 days ago',
                  unread: true,
                  isBill: true,
                ),
                _buildMessageCard(
                  name: 'Electricity Bill',
                  message: 'Bill payment reminder: KSH 4,000',
                  time: '2 days ago',
                  unread: true,
                  isBill: true,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showComposeDialog(context);
        },
        backgroundColor: Colors.blue.shade900,
        child: Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildMessageCard({
    required String name,
    required String message,
    required String time,
    required bool unread,
    bool isBill = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isBill ? Colors.orange.shade100 : Colors.blue.shade100,
            child: Icon(
              isBill ? Icons.receipt : Icons.person,
              color: isBill ? Colors.orange : Colors.blue.shade900,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: unread ? Colors.black87 : Colors.grey[600],
                    fontWeight: unread ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (unread)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  void _showComposeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('New Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Send to',
                border: OutlineInputBorder(),
              ),
              items: ['All Tenants', 'Specific Tenant'].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent!')),
              );
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
