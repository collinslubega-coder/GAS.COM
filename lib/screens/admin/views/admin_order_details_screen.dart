import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/order_model.dart'; // Import OrderModel
import 'package:gas_com/services/user_data_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  final OrderModel order; // Expect an OrderModel object as argument

  const AdminOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    final dateFormatter = DateFormat('d MMMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Consumer<UserDataService>(
        builder: (context, userDataService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultBorderRadious)),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order.id}",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: defaultPadding / 2),
                        Text("Date: ${dateFormatter.format(order.date)}",
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: defaultPadding / 2),
                        Text("Total: ${currencyFormatter.format(order.total)}",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            )),
                        const Divider(height: defaultPadding * 2),
                        Text("Customer Details",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: defaultPadding / 2),
                        Text("Name: ${order.customerName}"),
                        Text("Contact: ${order.customerContact}"),
                        Text("Address: ${order.deliveryAddress}"),
                        const Divider(height: defaultPadding * 2),
                        Text("Items (${order.items.length})",
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: defaultPadding / 2),
                        // Removed unnecessary .toList()
                        ...order.items.map(
                          (item) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.asset(item.imageUrl, width: 40),
                            title: Text(item.name),
                            trailing: Text(currencyFormatter.format(double.tryParse(item.price) ?? 0.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                Text("Order Status", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: order.status,
                        decoration: InputDecoration(
                          labelText: "Status",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(defaultBorderRadious),
                          ),
                        ),
                        items: <String>['Pending', 'Processing', 'Completed', 'Cancelled']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            // Update the order status in UserDataService
                            userDataService.updateOrderStatus(order.id, newValue);
                          }
                        },
                      ),
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