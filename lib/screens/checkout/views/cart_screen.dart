import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/services/cart_service.dart';
import 'package:provider/provider.dart';
import 'components/cart_item_card.dart';
import 'components/order_summery.dart';
import 'components/user_info_popup.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _handleCheckout(BuildContext context) {
    // This now *always* shows the confirmation popup.
    // The popup itself is smart enough to pre-fill the data.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => const UserInfoPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("My Kitchen")),
          bottomNavigationBar: cartService.items.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: ElevatedButton(
                      onPressed: () => _handleCheckout(context),
                      child: const Text("Checkout"),
                    ),
                  ),
                ),
          body: cartService.items.isEmpty
              ? const Center(
                  child: Text(
                  "Your kitchen is empty.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(defaultPadding),
                        itemCount: cartService.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: defaultPadding),
                        itemBuilder: (context, index) {
                          final item = cartService.items[index];
                          return CartItemCard(
                            item: item,
                            onRemove: () => cartService.removeItem(item),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      child: OrderSummaryCard(
                        subTotal: cartService.subtotal,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}