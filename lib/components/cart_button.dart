import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.price,
    this.title = "Add To Kitchen", // Updated text
    this.subTitle = "Total price",
    required this.press,
  });

  final double price;
  final String title, subTitle;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currencyFormatter.format(price),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 12),
                    )
                  ],
                ),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}