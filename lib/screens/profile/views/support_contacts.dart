import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

// Class name updated to match file name
class SupportContacts extends StatelessWidget { 
  const SupportContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support Contacts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            ContactCard(
              title: "Sales Team",
              contacts: const [
                "+256 750 783474",
                "+256 762 625956",
                "+256 709 802331",
              ],
              icon: Icons.call_outlined,
              iconColor: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: defaultPadding),
            const ContactCard(
              title: "Email Support",
              contacts: ["support@gas.com"],
              icon: Icons.email_outlined,
              iconColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.title,
    required this.contacts,
    required this.icon,
    this.iconColor,
  });

  final String title;
  final List<String> contacts;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
                const SizedBox(width: defaultPadding / 2),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: defaultPadding * 1.5),
            ...contacts.map((contact) => Text(
                  contact,
                  style: const TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}