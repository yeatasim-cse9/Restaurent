import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy order data
    final orders = [
      {
        'date': 'Oct 24, 2026',
        'id': '#ORD-89421',
        'items': '2x Chicken Burger, 1x Large Fries, 2x Cola',
        'total': '\$38.50',
        'status': 'Delivered',
        'statusColor': Colors.green,
      },
      {
        'date': 'Oct 18, 2026',
        'id': '#ORD-89201',
        'items': '1x Pepperoni Pizza, 1x Garlic Bread',
        'total': '\$24.00',
        'status': 'Delivered',
        'statusColor': Colors.green,
      },
      {
        'date': 'Sep 05, 2026',
        'id': '#ORD-88540',
        'items': '3x Spicy Chicken Taco, 1x Nachos',
        'total': '\$22.75',
        'status': 'Cancelled',
        'statusColor': Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['date'] as String,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      order['total'] as String,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  order['id'] as String,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order['items'] as String,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          order['status'] == 'Delivered'
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: order['statusColor'] as Color,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order['status'] as String,
                          style: TextStyle(
                            color: order['statusColor'] as Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6366F1),
                        side: const BorderSide(color: Color(0xFF6366F1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reorder'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
