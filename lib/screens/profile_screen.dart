import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- User Info and Profile Picture ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile_placeholder.jpg'), // Placeholder
                  ),
                  const SizedBox(height: 10),
                  const Text('Ana Silva', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Premium Member', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const Divider(),

            // --- Order History Section ---
            _buildSectionTitle('Order History'),
            _buildOrderTile(context, 'Modern Running', 69.99),
            _buildOrderTile(context, 'Wireless Headphone', 149.00),

            const Divider(),

            // --- Menu Options ---
            _buildSectionTitle('My Account'),
            _buildListTile(context, 'My Addresses', Icons.location_on),
            _buildListTile(context, 'Payment Methods', Icons.payment),
            _buildListTile(context, 'Notifications', Icons.notifications),

            const Divider(),

            // --- Support & Logout ---
            _buildSectionTitle('Support'),
            _buildListTile(context, 'Help & Support', Icons.help_outline),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Log out', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 5.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  Widget _buildOrderTile(BuildContext context, String product, double price) {
    return ListTile(
      leading: Container(width: 50, color: Colors.grey[200]), // Placeholder de imagen
      title: Text(product),
      trailing: Text('\$${price.toStringAsFixed(2)}'),
      onTap: () {},
    );
  }
}