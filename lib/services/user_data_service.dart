import 'dart:async'; // Import for Completer
import 'dart:convert';
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
  // New keys for username and password
  static const String _savedUsernameKey = 'savedUsername';
  static const String _savedPasswordKey = 'savedPassword';


  String? _userName;
  String? _userContact;
  List<String> _addresses = [];
  List<OrderModel> _orders = [];
  bool _isLoggedIn = false;
  String? _userRole;
  // New fields for user-defined username and password
  String? _userSavedUsername;
  String? _userSavedPassword;

  // Completer to signal when initial data loading is complete
  final Completer<void> _initializedCompleter = Completer<void>();
  Future<void> get initialized => _initializedCompleter.future;


  String? get userName => _userName;
  String? get userContact => _userContact;
  List<String> get addresses => _addresses;
  List<OrderModel> get orders => _orders;
  bool get isLoggedIn => _isLoggedIn;
  String? get userRole => _userRole;
  // New getters
  String? get userSavedUsername => _userSavedUsername;
  String? get userSavedPassword => _userSavedPassword;
  // New flag to check if user has set up credentials
  bool get hasSetCredentials => _userSavedUsername != null && _userSavedPassword != null;


  UserDataService() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(_nameKey);
    _userContact = prefs.getString(_contactKey);
    _addresses = prefs.getStringList(_addressesKey) ?? [];
    _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    _userRole = prefs.getString(_roleKey);
    // Load new user credentials
    _userSavedUsername = prefs.getString(_savedUsernameKey);
    _userSavedPassword = prefs.getString(_savedPasswordKey);

    await _loadOrders(); // Load existing orders from SharedPreferences

    // Complete the completer after all data is loaded
    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete();
    }
    notifyListeners();
  }

  Future<void> login({required String role, String? contact}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    _isLoggedIn = true;

    await prefs.setString(_roleKey, role);
    _userRole = role;

    if (contact != null) {
      await prefs.setString(_contactKey, contact);
      _userContact = contact;
    }
    notifyListeners();
  }
  // New login method for username and password
  Future<bool> loginWithCredentials({required String username, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString(_savedUsernameKey);
    final storedPassword = prefs.getString(_savedPasswordKey);

    if (username == storedUsername && password == storedPassword) {
      await prefs.setBool(_isLoggedInKey, true);
      _isLoggedIn = true;
      await prefs.setString(_roleKey, 'customer'); // Assume 'customer' role for credential login
      _userRole = 'customer';
      _userName = storedUsername; // Update userName from saved username
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Only remove the keys related to the current session status.
    // KEEPING: _nameKey, _contactKey, _addressesKey, _ordersKey, _savedUsernameKey, _savedPasswordKey
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_roleKey);
    
    // Reset in-memory states that are session-dependent
    _isLoggedIn = false;
    _userRole = null;
    // IMPORTANT: Do NOT reset _userName, _userContact, _addresses, _orders here.
    // These values should persist across logouts and be loaded by loadUserData() on app restart.
    
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

  // Modified addOrder to accept customer details
  Future<void> addOrder(
    List<ProductModel> items,
    double total,
    String customerName, // New
    String customerContact, // New
    String deliveryAddress, // New
  ) async {
    final orderId = "#GAS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
    final newOrder = OrderModel(
      id: orderId,
      date: DateTime.now(),
      items: items,
      total: total,
      customerName: customerName, // Pass to constructor
      customerContact: customerContact, // Pass to constructor
      deliveryAddress: deliveryAddress, // Pass to constructor
      status: 'Pending', // Default status for new orders
    );
    _orders.insert(0, newOrder);
    await _saveOrders();
    notifyListeners();
  }

  // New method to update order status
  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex].updateStatus(newStatus);
      _saveOrders(); // Persist the change
      notifyListeners();
    }
  }

  // New method to delete an order
  Future<void> deleteOrder(String orderId) async {
    _orders.removeWhere((order) => order.id == orderId);
    await _saveOrders();
    notifyListeners();
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

  // New method to set username and password
  Future<void> setCredentials({required String username, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedUsernameKey, username);
    await prefs.setString(_savedPasswordKey, password);
    _userSavedUsername = username;
    _userSavedPassword = password;
    notifyListeners();
  }
}