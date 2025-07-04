// lib/screens/home/views/components/explore_banner_card.dart

import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class ExploreBannerCard extends StatelessWidget {
  const ExploreBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore New\nGas Deals",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold, fontFamily: grandisExtendedFont),
            ),
            const SizedBox(height: defaultPadding),
            AspectRatio(
              aspectRatio: 2.5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/banner_large.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}