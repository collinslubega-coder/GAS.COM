import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: const [
          // **NEW QUESTIONS ADDED HERE**
          FaqItem(
            question: "What's the difference between a 'Refill' and a 'Full Set'?",
            answer:
                "A Refill is when you swap your empty cooking gas cylinder for a freshly filled one. A Full Set is a complete starter kit that includes a brand new gas cylinder, a 1.5m hose pipe, a gas regulator, and a cylinder grill.",
          ),
          FaqItem(
            question: "Do you offer free delivery?",
            answer:
                "Yes, we offer free and timely delivery for all orders to your specified location. Our goal is to get your cooking gas to you as quickly as possible without any extra charge.",
          ),
          FaqItem(
            question: "Which gas brands do you sell?",
            answer:
                "We deal in all major cooking gas brands available on the market. Our app provides a wide selection to ensure you can find and order your preferred brand with ease.",
          ),
          // Existing questions remain below
          FaqItem(
            question: "How do I place an order?",
            answer:
                "You can place an order by Browse our products, adding items to your kitchen (cart), and proceeding to checkout. You will be asked to confirm your delivery details before placing the order.",
          ),

          FaqItem(
            question: "What are the payment options?",
            answer:
                "We currently support Cash on Delivery. You can pay our delivery agent in cash when your order arrives at your doorstep.",
          ),
          FaqItem(
            question: "How long does delivery take?",
            answer:
                "We strive to deliver all orders within the same day. Once your order is placed, our team will call you to confirm the details and provide an estimated delivery time.",
          ),
          FaqItem(
            question: "Can I track my order?",
            answer:
                "Currently, we do not have a live tracking feature. However, our sales team will keep you updated via phone call about the status of your delivery.",
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(answer),
          )
        ],
      ),
    );
  }
}