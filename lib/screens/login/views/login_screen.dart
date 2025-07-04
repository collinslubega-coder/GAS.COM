import 'dart:convert';
import 'dart:math'; // Required for min() function
import 'package:flutter/material.dart';
import 'package:gas_com/models/order_model.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataService extends ChangeNotifier {
  static const String _nameKey = 'userName';
  static const String _contactKey = 'userContact';
  static const String _addressesKey = 'userAddresses';
  static const String _ordersKey = 'userOrders';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _roleKey = 'userRole';
  static const String _authCodeKey = 'userAuthCode'; // Added unique auth code key

  String? _userName;
  String? _userContact;
  List<String> _addresses = [];
  List<OrderModel> _orders = [];
  bool _isLoggedIn = false;
  String? _userRole;
  String? _userAuthCode; // Added unique auth code variable

  String? get userName => _userName;
  String? get userContact => _userContact;
  List<String> get addresses => _addresses;
  List<OrderModel> get orders => _orders;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  String? get userAuthCode => _userAuthCode; // Getter for the unique auth code

  late Future<void> initialized; // Added to track initialization state

  UserDataService() {
    initialized = loadUserData(); // Initialize the future here
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(_nameKey);
    _userContact = prefs.getString(_contactKey);
    _addresses = prefs.getStringList(_addressesKey) ?? [];
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userRole = prefs.getString(_roleKey);
    _userAuthCode = prefs.getString(_authCodeKey); // Load the unique auth code
    
    await _loadOrders(); // Load existing orders from SharedPreferences

    // --- MOCK DATA REMOVED ---
    // The previous block for adding mock data has been completely removed.
    // The _addMockOrders() method itself is also removed from this file.
    // --- END MOCK DATA REMOVAL ---

    notifyListeners();
  }

  // Helper to generate a unique authorization code
  String _generateAuthCode(String name) {
    final random = Random();
    final numbers = random.nextInt(9000) + 1000;
    final namePart = name.split(' ').first.toUpperCase().substring(0, min(4, name.length));
    return '$namePart-$numbers';
  }

  Future<void> login({required String role, String? authCode}) async { // Changed parameter from contact to authCode
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    _isLoggedIn = true;

    await prefs.setString(_roleKey, role);
    _userRole = role;

    if (authCode != null) {
      await prefs.setString(_authCodeKey, authCode); // Save the authCode if provided
      _userAuthCode = authCode; // Update in-memory variable
    }
    await loadUserData(); // Reload all data to ensure consistent state
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false); // Only clear login status
    await prefs.remove(_roleKey); // Remove role
    
    // Do NOT call prefs.clear() here. We want to keep _userAuthCode and orders.
    _isLoggedIn = false;
    _userRole = null;
    // Keep _userName, _userContact, _addresses, _orders, _userAuthCode in memory
    // These will be reloaded from prefs if needed or maintained until app is killed.
    notifyListeners();
  }
  
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey);
    if (ordersJson != null) {
      final List<dynamic> decoded = jsonDecode(ordersJson);
      _orders = decoded.map((item) => OrderModel.fromJson(item)).toList();
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_orders.map((order) => order.toJson()).toList());
    await prefs.setString(_ordersKey, encoded);
  }

  Future<String?> addOrder( // Modified to return String? (the new auth code)
    List<ProductModel> items,
    double total,
    String name, // Added name parameter
    String contact, // Added contact parameter
    String address, // Added address parameter
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? newAuthCode;

    if (_userAuthCode == null) { // If no unique auth code exists for this user/device
      newAuthCode = _generateAuthCode(name); // Generate one
      _userAuthCode = newAuthCode; // Update in-memory variable
      await prefs.setString(_authCodeKey, _userAuthCode!); // Save it to SharedPreferences
      
      // Also update user profile info if it's the first time
      await updateUserInfoAndAddress(name: name, contact: contact, address: address);
    }

    final orderId = "#GAS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final newOrder = OrderModel(
      id: orderId,
      date: DateTime.now(),
      items: items,
      total: total,
      customerName: name, // Added customerName
      customerContact: contact, // Added customerContact
      deliveryAddress: address, // Added deliveryAddress
    );
    _orders.insert(0, newOrder);
    await _saveOrders();
    notifyListeners();

    return newAuthCode; // Return the newly generated code
  }
  
  // Method to update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      await _saveOrders();
      notifyListeners();
    }
  }

  Future<void> updateUserInfoAndAddress({
    required String name,
    required String contact,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_nameKey, name);
    _userName = name;
    
    await prefs.setString(_contactKey, contact);
    _userContact = contact;

    if (!_addresses.contains(address)) {
      _addresses.add(address);
      await prefs.setStringList(_addressesKey, _addresses);
    }
    
    notifyListeners();
  }
  
  Future<void> updateProfile({required String newName, required String newContact}) async {
    final prefs = await SharedPreferences.getInstance();
    _userName = newName;
    _userContact = newContact;
    await prefs.setString(_nameKey, newName);
    await prefs.setString(_contactKey, newContact);
    notifyListeners();
  }

  Future<void> removeAddress(String addressToRemove) async {
    _addresses.remove(addressToRemove);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_addressesKey, _addresses);
    notifyListeners();
  }

  // Method to clear all user data
  Future<void> clearAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears everything!
    _isLoggedIn = false;
    _userRole = null;
    _userName = null;
    _userContact = null;
    _addresses = [];
    _orders = [];
    _userAuthCode = null; // Clear the unique auth code as well
    notifyListeners();
  }
}