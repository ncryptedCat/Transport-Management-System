import 'package:flutter/material.dart';

import '../others/map.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  _VehiclesScreenState createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  String filterStatus = 'All';
  List<String> vehicleList = List.generate(10, (index) => 'Vehicle ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search vehicles...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
            const SizedBox(height: 16),

            // Filter Chips for Status
            Wrap(
              spacing: 8.0,
              children: ['All', 'Active', 'Inactive'].map((status) {
                return ChoiceChip(
                  label: Text(status),
                  selected: filterStatus == status,
                  onSelected: (selected) {
                    setState(() {
                      filterStatus = selected ? status : 'All';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Vehicle List
            Expanded(
              child: ListView.builder(
                itemCount: vehicleList.length, // Replace with dynamic vehicle count
                itemBuilder: (context, index) {
                  // Use the selected filter to display vehicles
                  String status = index % 2 == 0 ? 'Active' : 'Inactive';
                  if (filterStatus == 'All' || filterStatus == status) {
                    return VehicleCard(
                      vehicleName: vehicleList[index],
                      status: status,
                    );
                  }
                  return Container(); // Don't show vehicle if it doesn't match filter
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for Adding Vehicles
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapsScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Vehicle Card Widget
class VehicleCard extends StatelessWidget {
  final String vehicleName;
  final String status;

  const VehicleCard({
    super.key,
    required this.vehicleName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: status == 'Active' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          child: Icon(
            status == 'Active' ? Icons.check_circle : Icons.error,
            color: status == 'Active' ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          vehicleName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Status: $status'),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {

          },
        ),
      ),
    );
  }
}
