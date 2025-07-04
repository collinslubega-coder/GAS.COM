import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/components/product/new_product_card.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart'; // Correctly importing the model
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/bookmark_service.dart';
import 'package:gas_com/services/local_product_service.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarks")),
      body: Consumer<BookmarkService>(
        builder: (context, bookmarkService, child) {
          // We use a FutureBuilder to get the full list of products once.
          return FutureBuilder<List<GroupedProduct>>(
            future: LocalProductService().getGroupedProducts(),
            builder: (context, snapshot) {
              // Show a loading indicator while waiting for the product list.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Show an error message if something goes wrong.
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No products available."));
              }

              // Once we have the full product list, we filter it to find the bookmarked ones.
              final bookmarkedProducts = snapshot.data!
                  .where((product) => bookmarkService.isBookmarked(product))
                  .toList();
              
              // If the user has no bookmarks, show a helpful message.
              if (bookmarkedProducts.isEmpty) {
                return const Center(
                  child: Text(
                    "You have no bookmarked items yet.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // Display the bookmarked products in a grid.
              return GridView.builder(
                padding: const EdgeInsets.all(defaultPadding),
                itemCount: bookmarkedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                ),
                itemBuilder: (context, index) {
                  final groupedProduct = bookmarkedProducts[index];
                  return NewProductCard(
                    product: groupedProduct,
                    // The category doesn't matter here, so we can pass a default.
                    selectedCategory: "All Products", 
                    press: () {
                      Navigator.pushNamed(
                          context, groupedProductDetailsScreenRoute,
                          arguments: groupedProduct);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}