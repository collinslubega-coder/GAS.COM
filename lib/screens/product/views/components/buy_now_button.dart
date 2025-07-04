import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class BuyNowButton extends StatelessWidget {
  const BuyNowButton({
    super.key,
    required this.press,
  });

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: press,
            child: const Text("Add to Kitchen"),
          ),
        ),
      ),
    );
  }
}