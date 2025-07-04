class GroupedProduct {
  final String brandName;
  final String imageUrl;
  final List<ProductModel> variations;
  final String displayPrice;

  GroupedProduct({
    required this.brandName,
    required this.imageUrl,
    required this.variations,
    required this.displayPrice,
  });

  // Convert a GroupedProduct instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'imageUrl': imageUrl,
      'variations': variations.map((v) => v.toJson()).toList(),
      'displayPrice': displayPrice,
    };
  }

  // Create a GroupedProduct instance from a JSON map.
  factory GroupedProduct.fromJson(Map<String, dynamic> json) {
    return GroupedProduct(
      brandName: json['brandName'],
      imageUrl: json['imageUrl'],
      variations: (json['variations'] as List)
          .map((v) => ProductModel.fromJson(v))
          .toList(),
      displayPrice: json['displayPrice'],
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  // Convert a ProductModel instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
    };
  }

  // Create a ProductModel from a JSON map.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      category: json['category'],
    );
  }
}