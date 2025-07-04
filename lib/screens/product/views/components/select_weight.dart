// lib/screens/product/views/components/select_weight.dart

import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';

class SelectWeight extends StatelessWidget {
  const SelectWeight({
    super.key,
    required this.variations,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<ProductModel> variations;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  // Helper to get the weight from the product name e.g "6kg" from "Stabex Gas 6kg"
  String _getWeightFromVariation(ProductModel variation) {
    final RegExp weightRegExp = RegExp(r"(\d+\s?KG)", caseSensitive: false);
    final match = weightRegExp.firstMatch(variation.name);
    return match?.group(1) ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Weight", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: defaultPadding / 2),
        // Removed the Card widget from here to match the desired UI style
        Wrap(
          spacing: defaultPadding / 2,
          runSpacing: defaultPadding / 2,
          children: List.generate(variations.length, (index) {
            final isSelected = index == selectedIndex;
            return OutlinedButton(
              onPressed: () => onTap(index),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                backgroundColor:
                    isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                foregroundColor: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
                side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Match button rounding
                ),
              ),
              child: Text(_getWeightFromVariation(variations.elementAt(index))),
            );
          }),
        ),
      ],
    );
  }
}