import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    final userDataService = Provider.of<UserDataService>(context, listen: false);
    _nameController = TextEditingController(text: userDataService.userName);
    _contactController = TextEditingController(text: userDataService.userContact);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      userDataService.updateProfile(
        newName: _nameController.text,
        newContact: _contactController.text,
      );
      // Go back to the profile screen after saving
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your full name",
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _contactController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Contact Number",
                  hintText: "e.g., 07XX XXX XXX",
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Save Changes"),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}