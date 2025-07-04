import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/cart_service.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/screens/checkout/views/set_credentials_screen.dart';


class UserInfoPopup extends StatefulWidget {
  const UserInfoPopup({super.key});

  @override
  State<UserInfoPopup> createState() => _UserInfoPopupState();
}

class _UserInfoPopupState extends State<UserInfoPopup> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _recipientNameController; // New controller
  late TextEditingController _recipientContactController; // New controller

  bool _forSomeoneElse = false; // State for the toggle

  @override
  void initState() {
    super.initState();
    final userDataService = Provider.of<UserDataService>(context, listen: false);

    // Initialize controllers with current user data
    _nameController = TextEditingController(text: userDataService.userName);
    _contactController = TextEditingController(text: userDataService.userContact);
    _addressController = userDataService.addresses.isNotEmpty ? TextEditingController(text: userDataService.addresses.last) : TextEditingController();

    // Initialize recipient controllers, pre-filling with user's data initially
    _recipientNameController = TextEditingController(text: userDataService.userName);
    _recipientContactController = TextEditingController(text: userDataService.userContact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _recipientNameController.dispose();
    _recipientContactController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      final cartService = Provider.of<CartService>(context, listen: false);

      String finalName;
      String finalContact;

      if (_forSomeoneElse) {
        finalName = _recipientNameController.text;
        finalContact = _recipientContactController.text;
      } else {
        finalName = _nameController.text;
        finalContact = _contactController.text;
      }

      // Update user info and address (always update the current user's details)
      userDataService.updateUserInfoAndAddress(
        name: _nameController.text,
        contact: _contactController.text,
        address: _addressController.text,
      );

      // Add the order with either user's or recipient's details
      await userDataService.addOrder(
        cartService.items.toList(),
        cartService.subtotal,
        finalName, // Pass customer name (recipient or self)
        finalContact, // Pass customer contact (recipient or self)
        _addressController.text, // Delivery address is always the same field
      );

      final subtotal = cartService.subtotal;
      cartService.clearCart();

      Navigator.pop(context); // Close the popup

      if (!userDataService.hasSetCredentials) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetCredentialsScreen()),
        );
      } else {
        Navigator.pushNamed(
          context,
          thanksForOrderScreenRoute,
          arguments: subtotal,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: defaultPadding,
          right: defaultPadding,
          top: defaultPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Confirm Your Details",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              const Text(
                "Please confirm your information below before placing your order.",
              ),
              const SizedBox(height: defaultPadding * 1.5),

              // Current User's Details - always shown
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (!_forSomeoneElse && (value == null || value.isEmpty)) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Your Name",
                  hintText: "Enter your full name",
                ),
                enabled: !_forSomeoneElse, // Disable if ordering for someone else
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _contactController,
                validator: (value) {
                  if (!_forSomeoneElse && (value == null || value.isEmpty)) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Your Contact Number",
                  hintText: "e.g., 07XX XXX XXX",
                ),
                enabled: !_forSomeoneElse, // Disable if ordering for someone else
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Delivery Address",
                  hintText: "e.g., Street Name, Town",
                ),
              ),
              const SizedBox(height: defaultPadding),

              // "Order for someone else" toggle
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Order for someone else?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: _forSomeoneElse,
                    onChanged: (bool value) {
                      setState(() {
                        _forSomeoneElse = value;
                        if (!value) {
                          // If switching back to self, re-populate recipient fields with user's data
                          final userDataService = Provider.of<UserDataService>(context, listen: false);
                          _recipientNameController.text = userDataService.userName ?? '';
                          _recipientContactController.text = userDataService.userContact ?? '';
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),

              // Recipient Details - conditionally displayed
              if (_forSomeoneElse) ...[
                TextFormField(
                  controller: _recipientNameController,
                  validator: (value) {
                    if (_forSomeoneElse && (value == null || value.isEmpty)) {
                      return 'Please enter recipient\'s name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Recipient's Name",
                    hintText: "Enter recipient's full name",
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _recipientContactController,
                  validator: (value) {
                    if (_forSomeoneElse && (value == null || value.isEmpty)) {
                      return 'Please enter recipient\'s contact number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Recipient's Contact Number",
                    hintText: "e.g., 07XX XXX XXX",
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],

              const SizedBox(height: defaultPadding), // Adjusted spacing before button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Proceed & Place Order"),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}