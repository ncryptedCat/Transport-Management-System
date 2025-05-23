// Placeholder for Dashboard Screen
import 'package:flutter/material.dart';

import '../home.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                DashboardCard(
                  title: 'Active Vehicles',
                  count: 15,
                  color: Colors.green,
                  icon: Icons.directions_car,
                ),
                DashboardCard(
                  title: 'Pending Deliveries',
                  count: 8,
                  color: Colors.orange,
                  icon: Icons.local_shipping,
                ),
                DashboardCard(
                  title: 'Total Vehicles',
                  count: 120,
                  color: Colors.blue,
                  icon: Icons.inventory,
                ),
                DashboardCard(
                  title: 'Reports',
                  count: 5,
                  color: Colors.red,
                  icon: Icons.analytics,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

