import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:intl/intl.dart';

class ThanksForOrderScreen extends StatelessWidget {
  // It now accepts the amount as a parameter.
  // Adding an optional 'arguments' parameter to address the specific error message,
  // even if not directly used within this screen's logic.
  const ThanksForOrderScreen({super.key, required this.amount, this.arguments});

  final double amount;
  final Object? arguments; // Added to address the "arguments is required" error

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_UG', symbol: 'UGX ');

    // ** THE FIX IS HERE **
    // 1. Check if the current theme is dark or light.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. Choose the correct image file based on the theme.
    final String imagePath = isDarkMode
        ? "assets/Illustration/success_dark.png"
        : "assets/Illustration/success_light.png";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Spacer(flex: 2),
            // 3. Use the dynamic imagePath variable here.
            Image.asset(
              imagePath,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            const SizedBox(height: defaultPadding * 2),
            Text(
              "Thanks for your order",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            const Text(
              "Your order is now being processed. We will call you shortly to confirm the details.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: defaultPadding * 2),
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(defaultBorderRadious),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order number"),
                      Text(
                        "#FDS639820", // This would be dynamic in a real app
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Amount paid"),
                      Text(
                        currencyFormatter.format(amount),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  entryPointScreenRoute,
                  (route) => false,
                );
              },
              child: const Text("Continue Shopping"),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}