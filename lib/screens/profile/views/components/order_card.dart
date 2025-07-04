import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../models/order_model.dart';

// This is the only line that needed fixing.
// The original code had a period instead of a colon.
import 'package:intl/intl.dart'; 

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    // These lines will now work correctly because the import is fixed.
    final currencyFormatter = NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    final dateFormatter = DateFormat('d MMMM yyyy, hh:mm a');

    final String productInfoTitle = order.items.map((item) => item.name).join(', ');

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: ExpansionTile(
        title: Text(
          productInfoTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(dateFormatter.format(order.date)),
        trailing: Text(
          currencyFormatter.format(order.total),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Items (${order.items.length})", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: defaultPadding / 2),
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
          )
        ],
      ),
    );
  }
}