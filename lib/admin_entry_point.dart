import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/entry_point.dart';
import 'package:gas_com/screens/admin/views/admin_dashboard_screen.dart';
import 'package:gas_com/screens/admin/views/admin_orders_screen.dart'; // Corrected import
import 'package:gas_com/screens/admin/views/admin_products_screen.dart';

class AdminEntryPoint extends StatefulWidget {
  const AdminEntryPoint({super.key});

  @override
  State<AdminEntryPoint> createState() => _AdminEntryPointState();
}

class _AdminEntryPointState extends State<AdminEntryPoint> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const AdminOrdersScreen(), // Corrected class name
    const AdminProductsScreen(),
  ];

  final List<String> _pageTitles = ["Dashboard", "Incoming Orders", "Products"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: "View Customer Shop",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EntryPoint()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}