import 'package:gas_com/models/product_model.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final List<ProductModel> items;
  final double total;
  final String customerName; // New field
  final String customerContact; // New field
  final String deliveryAddress; // New field
  String status; // New field, mutable for status updates

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.customerName, // New
    required this.customerContact, // New
    required this.deliveryAddress, // New
    this.status = 'Pending', // Default status
  });

  // Method to convert an OrderModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'customerName': customerName, // New
      'customerContact': customerContact, // New
      'deliveryAddress': deliveryAddress, // New
      'status': status, // New
    };
  }

  // Factory constructor to create an OrderModel from a JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((itemJson) => ProductModel.fromJson(itemJson))
          .toList(),
      total: json['total'],
      customerName: json['customerName'] ?? 'N/A', // Handle potential null
      customerContact: json['customerContact'] ?? 'N/A', // Handle potential null
      deliveryAddress: json['deliveryAddress'] ?? 'N/A', // Handle potential null
      status: json['status'] ?? 'Pending', // Handle potential null
    );
  }

  // Method to update the status (for admin panel)
  void updateStatus(String newStatus) {
    status = newStatus;
  }
}