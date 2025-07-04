import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Illustration/NoResultDarkTheme.png",
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: defaultPadding),
            Text(
              "Your cart is empty",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: defaultPadding),
            const Text(
              "Customer network effects freemium. Advisor android paradigm shift product management. Customer disruptive crowdsource",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
