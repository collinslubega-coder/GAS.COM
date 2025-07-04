import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/cart_service.dart';

class GroupedProductDetailScreen extends StatefulWidget {
  final GroupedProduct groupedProduct;
  const GroupedProductDetailScreen({super.key, required this.groupedProduct});

  @override
  State<GroupedProductDetailScreen> createState() =>
      _GroupedProductDetailScreenState();
}

class _GroupedProductDetailScreenState
    extends State<GroupedProductDetailScreen> {
  late ProductModel _selectedVariation;

  @override
  void initState() {
    super.initState();
    _selectedVariation = widget.groupedProduct.variations.first;
  }

  bool get isAccessory => widget.groupedProduct.variations.first.category == 'Gas Accessories';

  void _addItemToCart() {
    final cartService = Provider.of<CartService>(context, listen: false);
    cartService.addItem(_selectedVariation);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Added to Kitchen", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "cart");
              },
              child: const Text("Go to Kitchen"),
            ),
            const SizedBox(height: defaultPadding / 2),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              onPressed: () => Navigator.pop(context),
              child: const Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    final theme = Theme.of(context);
    final price = double.tryParse(_selectedVariation.price) ?? 0.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: theme.colorScheme.onSurface),
      ),
      // **THE CORRECT BUTTON IS HERE**
      // This is a single, full-width button that displays the price
      // and updates when the variation changes.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: ElevatedButton(
            onPressed: _addItemToCart,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price on the left
                Text(
                  currencyFormatter.format(price),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // "Add to Kitchen" text on the right
                const Text("Add to Kitchen"),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImages(
              imageUrl: _selectedVariation.imageUrl,
            ),
            TopRoundedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text(_selectedVariation.name, style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  if (!isAccessory) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Variation", style: theme.textTheme.titleMedium),
                          const SizedBox(height: defaultPadding),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: widget.groupedProduct.variations.map((variation) {
                              final isSelected = _selectedVariation.id == variation.id;
                              return OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedVariation = variation;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected ? theme.primaryColor : Colors.transparent,
                                  foregroundColor: isSelected ? Colors.white : theme.textTheme.bodyLarge!.color,
                                  side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                                ),
                                child: Text(variation.name.replaceAll(widget.groupedProduct.brandName, '').trim()),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: defaultPadding * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
      padding: const EdgeInsets.fromLTRB(defaultPadding, 30, defaultPadding, defaultPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}

class ProductImages extends StatelessWidget {
  const ProductImages({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: screenWidth,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}