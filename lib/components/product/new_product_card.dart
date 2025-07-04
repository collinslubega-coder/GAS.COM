import 'package:flutter/material.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:gas_com/services/bookmark_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/constants.dart';

class NewProductCard extends StatelessWidget {
  final GroupedProduct product;
  final String selectedCategory;
  final VoidCallback press;

  const NewProductCard({
    super.key,
    required this.product,
    required this.selectedCategory,
    required this.press,
  });

  String _getPriceForCategory() {
    try {
      if (selectedCategory == "Gas Refill") {
        return product.variations
            .firstWhere((v) => v.category == "Gas Refill")
            .price;
      }
      if (selectedCategory == "Gas Full Set") {
        return product.variations
            .firstWhere((v) => v.category == "Gas Full Set")
            .price;
      }
    } catch (e) {
      // If a specific variation doesn't exist, fall back to the cheapest overall.
    }
    // For "All Products" and "Gas Accessories", or as a fallback, show the cheapest price.
    final sortedVariations = List<ProductModel>.from(product.variations)
      ..sort((a, b) => (double.tryParse(a.price) ?? double.infinity)
          .compareTo(double.tryParse(b.price) ?? double.infinity));
    return sortedVariations.first.price;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    final price = double.tryParse(_getPriceForCategory()) ?? 0.0;

    return Consumer<BookmarkService>(
      builder: (context, bookmarkService, child) {
        final isBookmarked = bookmarkService.isBookmarked(product);
        return GestureDetector(
          onTap: press,
          child: Card(
            elevation: 0.5,
            shadowColor: Colors.black12,
            color: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              product.brandName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              currencyFormatter.format(price),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      bookmarkService.toggleBookmark(product);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}