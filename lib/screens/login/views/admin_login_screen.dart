import 'package:flutter/material.dart';
import 'package:gas_com/admin_entry_point.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  // This is a simple, hardcoded password for local testing
  final String _adminPassword = "admin";

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _adminPassword) {
        final userDataService = Provider.of<UserDataService>(context, listen: false);
        // Log in the user with the 'admin' role
        userDataService.login(role: 'admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminEntryPoint()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Admin Panel", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: defaultPadding * 2),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the admin password';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Admin Password",
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}