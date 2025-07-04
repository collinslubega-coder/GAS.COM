import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Method")),
      body: const Center(
        child: Text("Payment Screen - To be rebuilt"),
      ),
    );
  }
}