import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:gas_com/services/local_product_service.dart';
import 'add_edit_product_screen.dart'; // Import the new screen

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final LocalProductService _productService = LocalProductService();
  late Future<List<GroupedProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getGroupedProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _productService.getGroupedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GroupedProduct>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Could not load products."));
          }
          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final groupedProduct = products[index];
              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                margin: const EdgeInsets.only(bottom: defaultPadding),
                child: ListTile(
                  leading: Image.asset(groupedProduct.imageUrl, width: 48, height: 48),
                  title: Text(groupedProduct.brandName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${groupedProduct.variations.length} variations"),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor),
                    onPressed: () async {
                      // Navigate to the new edit screen and wait for a result
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProductScreen(groupedProduct: groupedProduct),
                        ),
                      );
                      // Refresh the product list when returning
                      _refreshProducts();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            // Navigate to the add screen and wait for a result
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditProductScreen(),
              ),
            );
            // Refresh the product list when returning
            _refreshProducts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}