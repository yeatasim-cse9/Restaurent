import 'package:flutter/material.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Security & Privacy',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Security',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            title: 'Change Password',
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            title: 'Two-Factor Authentication',
            icon: Icons.security_rounded,
            trailingText: 'Off',
            onTap: () {},
          ),
          
          const SizedBox(height: 40),
          
          const Text(
            'Privacy',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            title: 'Data Sharing Settings',
            icon: Icons.share_rounded,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {},
          ),
          
          const SizedBox(height: 40),
          
          const Text(
            'Account Management',
            style: TextStyle(
              color: Color(0xFFEF4444), // Red to denote danger area
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionTile(
            title: 'Delete Account',
            icon: Icons.delete_outline_rounded,
            isDestructive: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? trailingText,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0F172A);
    final bgColor = isDestructive ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC);
    final borderColor = isDestructive ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: trailingText != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trailingText,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
                ],
              )
            : const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
