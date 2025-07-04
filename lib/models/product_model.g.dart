// lib/models/product_model.dart

// This is the main class we will use to display products in our UI grids.
// It holds a brand name and a list of all its available product variations.
class GroupedProduct {
  final String brandName;
  final String imageUrl; // This will be our local asset path, e.g., "assets/images/shell_gas.jpg"
  final List<ProductModel> variations;

  GroupedProduct({
    required this.brandName,
    required this.imageUrl,
    required this.variations,
  });
}

// This class represents a single, specific product variation fetched from WooCommerce.
class ProductModel {
  final int id;
  final String name;
  final String price;
  final String imageUrl; // The live image URL from WooCommerce
  final String description;
  final List<Category> categories;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.categories,
  });

  // This factory constructor safely builds a ProductModel from JSON data.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Safely parse categories
    List<Category> categoriesList = [];
    if (json['categories'] != null && json['categories'] is List) {
      categoriesList = (json['categories'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name Provided',
      price: json['price']?.toString() ?? '0.00',
      imageUrl: (json['images'] as List).isNotEmpty
          ? json['images'][0]['src']
          : 'https://via.placeholder.com/150', // A fallback image
      description: (json['description'] as String? ?? '')
          .replaceAll(RegExp(r'<[^>]*>'), ''), // Removes HTML tags from description
      categories: categoriesList,
    );
  }
}

// This class represents a single category from WooCommerce.
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Uncategorized',
    );
  }
}