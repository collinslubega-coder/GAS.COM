import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:gas_com/screens/profile/views/components/order_card.dart'; // Keep if OrderCard is still useful elsewhere, but not directly used here for the list item
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date and currency formatting
import 'package:gas_com/route/route_constants.dart'; // Import route constants for navigation
import 'package:gas_com/models/order_model.dart'; // Import OrderModel

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    final dateFormatter = DateFormat('d MMM, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Orders"),
      ),
      body: Consumer<UserDataService>(
        builder: (context, userDataService, child) {
          if (userDataService.orders.isEmpty) {
            return const Center(
              child: Text(
                "There are no orders yet.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: userDataService.orders.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: defaultPadding),
            itemBuilder: (context, index) {
              final order = userDataService.orders[index];
              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                margin: EdgeInsets.zero, // Remove default margin as ListView.separated handles spacing
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  onTap: () {
                    // Navigate to order details screen
                    Navigator.pushNamed(
                      context,
                      adminOrderDetailsScreenRoute, //
                      arguments: order,
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Text(
                      order.customerName.isNotEmpty ? order.customerName[0].toUpperCase() : '?',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    order.customerName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID: ${order.id}"),
                      Text("Total: ${currencyFormatter.format(order.total)}"),
                      Text("Status: ${order.status}"),
                      Text("Date: ${dateFormatter.format(order.date)}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: errorColor), //
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Delete Order'),
                            content: Text('Are you sure you want to delete order ${order.id}? This action cannot be undone.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  userDataService.deleteOrder(order.id); // Call the new delete method
                                  Navigator.of(dialogContext).pop(); // Close dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}