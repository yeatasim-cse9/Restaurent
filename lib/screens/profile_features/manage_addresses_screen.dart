import 'package:flutter/material.dart';

class ManageAddressesScreen extends StatelessWidget {
  const ManageAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {
        'title': 'Home',
        'address': '15 Water Street Fremont, CA 94536',
        'isDefault': true,
        'icon': Icons.home_rounded,
      },
      {
        'title': 'Work',
        'address': '88 Gourmet Boulevard, Tech Park, CA 94538',
        'isDefault': false,
        'icon': Icons.work_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Addresses',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: addresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = addresses[index];
          final isDefault = item['isDefault'] as bool;
          
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDefault ? const Color(0xFF6366F1).withOpacity(0.05) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDefault ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                width: isDefault ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDefault ? const Color(0xFF6366F1).withOpacity(0.1) : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: isDefault ? const Color(0xFF6366F1) : const Color(0xFF64748B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['address'] as String,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Color(0xFF94A3B8)),
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366F1),
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
