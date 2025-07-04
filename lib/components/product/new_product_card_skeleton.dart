// lib/components/product/new_product_card_skeleton.dart

import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class NewProductCardSkeleton extends StatelessWidget {
  const NewProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding / 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Container(
              height: 16,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(height: defaultPadding / 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}