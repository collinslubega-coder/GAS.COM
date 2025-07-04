// lib/screens/product/views/components/add_to_bag_bar.dart

import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class AddToBagBar extends StatelessWidget {
  const AddToBagBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          children: [
            Expanded(
              flex: 3, // Give more space to the primary button
              child: ElevatedButton(
                onPressed: () {
                  // Add to cart logic will go here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                ),
                child: const Text("Add To Kitchen"),
              ),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: () {
                  // Add to wishlist logic will go here
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                  )
                ),
                child: const Text("Add To Wishlist"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}