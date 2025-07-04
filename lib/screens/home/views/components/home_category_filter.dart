import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_com/constants.dart';

class HomeCategoryFilter extends StatelessWidget {
  const HomeCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    // The categories, including "All Products" for the default view.
    final List<Map<String, String>> categories = [
      {"name": "All Products"},
      {"name": "Gas Accessories", "icon": "assets/icons/gas_accessories.svg"},
      {"name": "Gas Refill", "icon": "assets/icons/gas_refill.svg"},
      {"name": "Gas Full Set", "icon": "assets/icons/gas_fullset.svg"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          categories.length,
          (index) {
            final category = categories[index];
            final bool isSelected = selectedCategory == category["name"];
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? defaultPadding : defaultPadding / 2,
                right: index == categories.length - 1 ? defaultPadding : 0,
              ),
              child: OutlinedButton(
                onPressed: () => onCategorySelected(category["name"]!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  shape: const StadiumBorder(),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.3),
                  )
                ),
                child: Row(
                  children: [
                    if (category["icon"] != null)
                      SvgPicture.asset(
                        category["icon"]!,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          isSelected 
                            ? Colors.white 
                            : Theme.of(context).textTheme.bodyLarge!.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    if (category["icon"] != null) const SizedBox(width: defaultPadding / 2),
                    Text(category["name"]!),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}