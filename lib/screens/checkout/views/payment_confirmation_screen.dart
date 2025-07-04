import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_com/constants.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Order"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/icons/Cash.svg", height: 64, colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),),
                      const SizedBox(height: defaultPadding),
                      Text(
                        "Cash on Delivery",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: defaultPadding / 2),
                      const Text(
                        "You can pay with cash when your order is delivered to your address.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () {
                  // We will create this screen next
                  // Navigator.pushNamed(context, thanksForOrderScreenRoute);
                },
                child: const Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}