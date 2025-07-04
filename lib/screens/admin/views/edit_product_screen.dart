import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:intl/intl.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.product.price);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.product.name}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // Image Section
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(widget.product.imageUrl),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () {
                        // Placeholder for image picking logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Image picker would open here.")),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: defaultPadding * 2),

            // Price Editing Section
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Price",
                prefixText: "${currencyFormatter.currencySymbol} ",
              ),
            ),
            const SizedBox(height: defaultPadding * 2),

            ElevatedButton(
              onPressed: () {
                // Placeholder for save logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved! (Simulated) - New price would be ${_priceController.text}")),
                );
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}