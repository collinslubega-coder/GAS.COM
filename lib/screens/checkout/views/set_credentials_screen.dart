// lib/screens/checkout/views/set_credentials_screen.dart

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/entry_point.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';

class SetCredentialsScreen extends StatefulWidget {
  const SetCredentialsScreen({super.key});

  @override
  State<SetCredentialsScreen> createState() => _SetCredentialsScreenState();
}

class _SetCredentialsScreenState extends State<SetCredentialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userDataService = Provider.of<UserDataService>(context, listen: false);
    // Pre-fill username with current user name if available
    _usernameController.text = userDataService.userName ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      await userDataService.setCredentials(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credentials set successfully!")),
      );

      // Navigate to the main entry point after setting credentials
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EntryPoint()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Up Your Account"),
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create your login details for future access.",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: defaultPadding * 2),
                TextFormField(
                  controller: _usernameController,
                  validator: RequiredValidator(errorText: 'Username is required'),
                  decoration: const InputDecoration(
                    labelText: "Username",
                    hintText: "Choose a username",
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _passwordController,
                  validator: passwordValidator,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                  ),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (val) => MatchValidator(errorText: pasNotMatchErrorText)
                      .validateMatch(val!, _passwordController.text),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Re-enter your password",
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("Save & Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}