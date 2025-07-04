import 'package:flutter/material.dart';
// Note: Corrected import paths if they were 'gas.com' to 'gas_com' based on previous context
import 'package:gas_com/components/product/new_product_card.dart';
import 'package:gas_com/components/product/new_product_card_skeleton.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/models/product_model.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/local_product_service.dart';
import 'components/explore_banner_card.dart';
import 'components/home_category_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalProductService _service = LocalProductService();
  List<GroupedProduct> _allProducts = [];
  List<GroupedProduct> _filteredProducts = [];
  String _selectedCategory = "All Products";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (!_isLoading) setState(() => _isLoading = true);
    final products = await _service.getGroupedProducts();
    if (mounted) {
      setState(() {
        _allProducts = products;
        _filterProducts();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    List<GroupedProduct> tempProducts;
    if (_selectedCategory == "Gas Accessories") {
      tempProducts = _allProducts
          .where((p) =>
              p.variations.any((v) => v.category == 'Gas Accessories'))
          .toList();
    } else {
      tempProducts = _allProducts
          .where((p) =>
              p.variations.any((v) => v.category != 'Gas Accessories'))
          .toList();
    }
    setState(() => _filteredProducts = tempProducts);
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _filterProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ExploreBannerCard()),
            HomeCategoryFilter(
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: _isLoading
                  ? _buildLoadingSkeleton()
                  : GridView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: defaultPadding),
                      itemCount: _filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                      ),
                      itemBuilder: (context, index) {
                        final groupedProduct = _filteredProducts[index];
                        return NewProductCard(
                          product: groupedProduct,
                          selectedCategory: _selectedCategory,
                          press: () {
                            Navigator.pushNamed(
                                context, groupedProductDetailsScreenRoute,
                                arguments: groupedProduct);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
      ),
      itemBuilder: (context, index) => const NewProductCardSkeleton(),
    );
  }
}
