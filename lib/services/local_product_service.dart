import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class LocalProductService {
  // --- Singleton Setup ---
  static final LocalProductService _instance = LocalProductService._internal();
  factory LocalProductService() {
    return _instance;
  }
  LocalProductService._internal();

  // --- Constants ---
  static const String _productsKey = 'groupedProducts';

  // --- Data Storage (In-Memory) ---
  List<GroupedProduct> _groupedProducts = [];
  bool _isInitialized = false;

  // --- Public Methods ---
  Future<List<GroupedProduct>> getGroupedProducts() async {
    if (!_isInitialized) {
      await _initializeProducts();
    }
    return List<GroupedProduct>.from(_groupedProducts);
  }

  Future<void> saveGroupedProduct(GroupedProduct productToSave) async {
    if (!_isInitialized) await getGroupedProducts(); // Ensure loaded

    final index = _groupedProducts.indexWhere((p) => p.brandName == productToSave.brandName);

    if (index != -1) {
      _groupedProducts[index] = productToSave;
    } else {
      _groupedProducts.add(productToSave);
    }
    _sortProducts();
    await _saveToPrefs();
  }

  Future<void> deleteGroupedProduct(String brandName) async {
    if (!_isInitialized) await getGroupedProducts(); // Ensure loaded
    _groupedProducts.removeWhere((p) => p.brandName == brandName);
    await _saveToPrefs();
  }

  // --- Internal Helper Methods ---

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _groupedProducts.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_productsKey, encodedData);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_productsKey);
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _groupedProducts =
          decodedData.map((item) => GroupedProduct.fromJson(item)).toList();
    }
  }

  void _sortProducts() {
    const popularOrder = [
      "Stabex Gas", "Shell Gas", "Total Gas", "K-Gas", "Oryx Energies",
      "Lake Gas", "Ola Energy", "Rubis Gas", "Mogas", "Hass Gas", "Al-Mass Gas",
      "Hashi Gas", "Jibu Gas", "Easy Gas", "DC Gas", "Ven Gas", "GP Global Gas",
      "Ugas", "Meru Gas", "Pet Gas"
    ];

    _groupedProducts.sort((a, b) {
      final indexA = popularOrder.indexOf(a.brandName);
      final indexB = popularOrder.indexOf(b.brandName);
      if (indexA == -1) return 1;
      if (indexB == -1) return -1;
      return indexA.compareTo(indexB);
    });
  }

  Future<void> _initializeProducts() async {
    await _loadFromPrefs();
    // If no data is in prefs, load the initial default data.
    if (_groupedProducts.isEmpty) {
      _processRawData();
      await _saveToPrefs(); // Save the initial data
    }
    _isInitialized = true;
  }

  void _processRawData() {
    final allProductsData = [
       {'name': "OLA ENERGY 6KG REFILL", 'price': 53000},
      {'name': "OLA ENERGY 12KG FULLSET", 'price': 270000},
      {'name': "OLA ENERGY 12KG REFILL", 'price': 105000},
      {'name': "OLA GAS 6KG FULLSET", 'price': 150000},
      {'name': "RUBIS GAS 6KG REFILL", 'price': 53000},
      {'name': "K-GAS 12KG FULLSET", 'price': 270000},
      {'name': "K-GAS 6KG REFILL", 'price': 53000},
      {'name': "K GAS 12KG REFILL", 'price': 105000},
      {'name': "K GAS 6KG FULLSET", 'price': 170000},
      {'name': "MOGAS 13KG REFILL", 'price': 105000},
      {'name': "MOGAS 6KG REFILL", 'price': 55000},
      {'name': "HASS GAS 12KG REFILL", 'price': 105000},
      {'name': "HASS GAS 6KG REFILL", 'price': 53000},
      {'name': "AL-MASS GAS 6KG REFILL", 'price': 53000},
      {'name': "TOTAL GAS 3KG REFILL", 'price': 30000},
      {'name': "TOTAL GAS 6KG REFILL", 'price': 53000},
      {'name': "TOTAL GAS 12.5KG REFILL", 'price': 105000},
      {'name': "TOTAL GAS 6KG FULLSET", 'price': 145000},
      {'name': "TOTAL GAS 12.5KG FULLSET", 'price': 250000},
      {'name': "ORYX ENERGIES 13KG REFILL", 'price': 105000},
      {'name': "ORXY ENERGIES 12KG FULLSET", 'price': 270000},
      {'name': "ORYX ENERGIES 6KG FULLSET", 'price': 155000},
      {'name': "ORYX 6KG REFILL", 'price': 53000},
      {'name': "HASHI GAS 6KG REFILL", 'price': 53000},
      {'name': "HASHI GAS 12KG REFILL", 'price': 105000},
      {'name': "JIBU GAS 6KG REFILL", 'price': 53000},
      {'name': "JIBU GAS 12KG REFILL", 'price': 100000},
      {'name': "EASY GAS 6KG REFILL", 'price': 53000},
      {'name': "EASY GAS 12KG FULLSET", 'price': 250000},
      {'name': "DC GAS 6KG FULLSET", 'price': 150000},
      {'name': "DC GAS 12KG REFILL", 'price': 105000},
      {'name': "DC GAS 6KG REFILL", 'price': 53000},
      {'name': "DC GAS 12KG FULLSET", 'price': 270000},
      {'name': "GRILL", 'price': 20000},
      {'name': "REGULATOR", 'price': 50000},
      {'name': "GAS BURNER", 'price': 20000},
      {'name': "GAS COOKER", 'price': 170000},
      {'name': "VEN GAS 6KG REFILL", 'price': 53000},
      {'name': "VEN GAS 12KG REFILL", 'price': 105000},
      {'name': "LAKE GAS 6KG REFILL", 'price': 53000},
      {'name': "LAKE GAS 12KG REFILL", 'price': 105000},
      {'name': "LAKE GAS 6KG FULLSET", 'price': 160000},
      {'name': "LAKE GAS 12KG FULLSET", 'price': 250000},
      {'name': "GP GLOBAL 6KG REFILL", 'price': 53000},
      {'name': "UGAS 6KG REFILL", 'price': 50000},
      {'name': "UGAS 12KG REFILL", 'price': 100000},
      {'name': "MERU GAS 6KG FULLSET", 'price': 150000},
      {'name': "1.5 METRE HOSE PIPE", 'price': 20000},
      {'name': "PET GAS 6KG REFILL", 'price': 50000},
      {'name': "SHELL GAS 6KG REFILL", 'price': 55000},
      {'name': "SHELL GAS 12KG REFILL", 'price': 105000},
      {'name': "SHELL GAS 6KG FULLSET", 'price': 157000},
      {'name': "SHELL GAS 12KG FULLSET", 'price': 250000},
      {'name': "STABEX GAS 12KG REFILL", 'price': 105000},
      {'name': "STABEX GAS 6KG FULLSET", 'price': 150000},
      {'name': "STABEX GAS 12KG FULLSET", 'price': 270000},
      {'name': "STABEX GAS 6KG REFILL", 'price': 53000},
    ];

     final brands = {
      "Ola Energy": "OLA", "Rubis Gas": "RUBIS", "K-Gas": "K-GAS", "Mogas": "MOGAS",
      "Hass Gas": "HASS", "Al-Mass Gas": "AL-MASS", "Total Gas": "TOTAL",
      "Oryx Energies": "ORYX", "Hashi Gas": "HASHI", "Jibu Gas": "JIBU",
      "Easy Gas": "EASY", "DC Gas": "DC", "Ven Gas": "VEN", "Lake Gas": "LAKE",
      "GP Global Gas": "GP GLOBAL", "Ugas": "UGAS", "Meru Gas": "MERU",
      "Pet Gas": "PET", "Shell Gas": "SHELL", "Stabex Gas": "STABEX"
    };

    final accessories = ["GRILL", "REGULATOR", "GAS BURNER", "GAS COOKER", "HOSE PIPE"];
    
    List<GroupedProduct> products = [];
    int idCounter = 1;

    brands.forEach((brandName, brandKey) {
      final variations = allProductsData
          .where((p) => (p['name'] as String).toUpperCase().contains(brandKey))
          .map((p) {
            final name = p['name'] as String;
            final category = name.toUpperCase().contains('REFILL') ? 'Gas Refill' : 'Gas Full Set';
            return ProductModel(
              id: idCounter++,
              name: name,
              price: p['price'].toString(),
              imageUrl: _getImageForBrand(brandKey),
              description: "A high-quality gas product from $brandName.",
              category: category,
            );
          }).toList();
      
      if (variations.isNotEmpty) {
        final lowestPrice = variations
            .map((v) => double.tryParse(v.price) ?? double.infinity)
            .reduce((a, b) => a < b ? a : b);

        products.add(GroupedProduct(
          brandName: brandName,
          imageUrl: _getImageForBrand(brandKey),
          variations: variations,
          displayPrice: lowestPrice.toStringAsFixed(0),
        ));
      }
    });

    for (var accName in accessories) {
      final accData = allProductsData.firstWhere((p) => (p['name'] as String).toUpperCase().contains(accName), orElse: () => {});
      if (accData.isNotEmpty) {
        products.add(GroupedProduct(
          brandName: accData['name'] as String,
          imageUrl: _getImageForBrand(accName),
          variations: [
            ProductModel(
              id: idCounter++,
              name: accData['name'] as String,
              price: accData['price'].toString(),
              imageUrl: _getImageForBrand(accName),
              description: "A high-quality gas accessory.",
              category: "Gas Accessories",
            )
          ],
          displayPrice: accData['price'].toString(),
        ));
      }
    }
    _groupedProducts = products;
    _sortProducts();
  }

  String _getImageForBrand(String brandName) {
    final upperCaseName = brandName.toUpperCase();

    const imageMap = {
      'STABEX': 'assets/images/stabex_gas.jpg',
      'SHELL': 'assets/images/shell_gas.jpg',
      'TOTAL': 'assets/images/total_gas.jpg',
      'K-GAS': 'assets/images/k_gas.jpg',
      'ORYX': 'assets/images/gas_cylinder.png',
      'LAKE': 'assets/images/lake_gas.jpg',
      'OLA': 'assets/images/gas_cylinder.png',
      'HASS': 'assets/images/gas_cylinder.png',
      'HASHI': 'assets/images/hashi_gas.jpg',
      'JIBU': 'assets/images/gas_cylinder.png',
      'EASY': 'assets/images/gas_cylinder.png',
      'DC': 'assets/images/gas_cylinder.png',
      'UGAS': 'assets/images/gas_cylinder.png',
      'VEN': 'assets/images/gas_cylinder.png',
    };

    for (var key in imageMap.keys) {
      if (upperCaseName.contains(key)) {
        return imageMap[key]!;
      }
    }
    return 'assets/images/gas_cylinder.png';
  }
}