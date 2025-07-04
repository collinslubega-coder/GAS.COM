import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:gas_com/services/local_product_service.dart';
import 'package:image_picker/image_picker.dart';

class AddEditProductScreen extends StatefulWidget {
  final GroupedProduct? groupedProduct;

  const AddEditProductScreen({super.key, this.groupedProduct});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandNameController;
  late TextEditingController _descriptionController;
  late List<ProductModel> _variations;
  String _imageUrl = 'assets/images/gas_cylinder.png';
  File? _imageFile;
  final LocalProductService _productService = LocalProductService();

  @override
  void initState() {
    super.initState();
    _brandNameController =
        TextEditingController(text: widget.groupedProduct?.brandName ?? '');
    _descriptionController = TextEditingController(
        text: widget.groupedProduct?.variations.isNotEmpty == true
            ? widget.groupedProduct!.variations.first.description
            : '');
    _variations = widget.groupedProduct?.variations.map((v) => v).toList() ?? [];
    if (widget.groupedProduct != null) {
      _imageUrl = widget.groupedProduct!.imageUrl;
    }
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_variations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one variation.')),
        );
        return;
      }

      final groupedProduct = GroupedProduct(
        brandName: _brandNameController.text,
        imageUrl: _imageFile?.path ?? _imageUrl,
        variations: _variations,
        displayPrice: _variations
            .map((v) => double.tryParse(v.price) ?? double.infinity)
            .reduce((a, b) => a < b ? a : b)
            .toStringAsFixed(0),
      );

      _productService.saveGroupedProduct(groupedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully!')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  void _showVariationDialog({ProductModel? variation, int? index}) {
    final isEditing = variation != null;
    final nameController = TextEditingController(text: variation?.name ?? '');
    final priceController = TextEditingController(text: variation?.price ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Variation' : 'Add Variation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Variation Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final newVariation = ProductModel(
                    id: variation?.id ?? DateTime.now().millisecondsSinceEpoch,
                    name: nameController.text,
                    price: priceController.text,
                    imageUrl: _imageFile?.path ?? _imageUrl,
                    description: _descriptionController.text,
                    category: 'Gas Refill', // Default category
                  );
                  if (isEditing && index != null) {
                    _variations[index] = newVariation;
                  } else {
                    _variations.add(newVariation);
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupedProduct == null
            ? 'Add Product'
            : 'Edit Product'),
        actions: [
          if (widget.groupedProduct != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: errorColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: const Text('Are you sure you want to delete this product? This cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _productService.deleteGroupedProduct(widget.groupedProduct!.brandName);
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context, true); // Go back with success
                        },
                        child: const Text('Delete', style: TextStyle(color: errorColor)),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Section
              SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _imageFile == null
                        ? Image.asset(_imageUrl)
                        : Image.file(_imageFile!),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Camera'),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_album),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        icon:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              TextFormField(
                controller: _brandNameController,
                decoration: const InputDecoration(labelText: 'Brand Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brand name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding * 2),
              // Variations Section
              const Divider(),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Variations',
                      style: Theme.of(context).textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showVariationDialog(),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              if (_variations.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text('No variations added yet. Tap the \'+\' icon to add one.'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _variations.length,
                  itemBuilder: (context, index) {
                    final variation = _variations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: defaultPadding / 2),
                      child: ListTile(
                        title: Text(variation.name),
                        subtitle: Text('Price: ${variation.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: primaryColor),
                              onPressed: () => _showVariationDialog(
                                  variation: variation, index: index),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: errorColor),
                              onPressed: () {
                                setState(() {
                                  _variations.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}