import 'package:flutter/material.dart';

/// Screen for managing user notification preferences.
///
/// Allows the user to toggle settings for:
/// - Order updates
/// - Promotions & offers
/// - New restaurants alerts
/// - Weekly email newsletters
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _newRestaurants = true;
  bool _emailNewsletter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle('Push Notifications'),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Order Updates',
            subtitle: 'Get real-time updates on your order status',
            value: _orderUpdates,
            onChanged: (val) => setState(() => _orderUpdates = val),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            title: 'Promotions & Offers',
            subtitle: 'Receive coupons, promotions, and discounts',
            value: _promotions,
            onChanged: (val) => setState(() => _promotions = val),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            title: 'New Restaurants',
            subtitle: 'Be the first to know when new places are added',
            value: _newRestaurants,
            onChanged: (val) => setState(() => _newRestaurants = val),
          ),
          
          const SizedBox(height: 40),
          
          _buildSectionTitle('Email Notifications'),
          const SizedBox(height: 16),
          _buildSwitchTile(
            title: 'Weekly Newsletter',
            subtitle: 'A weekly digest of the best food trends',
            value: _emailNewsletter,
            onChanged: (val) => setState(() => _emailNewsletter = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6366F1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
