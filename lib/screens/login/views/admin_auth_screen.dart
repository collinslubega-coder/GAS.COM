import 'package:flutter/material.dart';
import 'package:gas_com/admin_entry_point.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // The admin password, consistent with previous implementations
  final String _adminPassword = "gasA@25"; // From PasswordScreen or admin_login_screen

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final enteredPassword = _passwordController.text;

      if (enteredPassword == _adminPassword) {
        final userDataService = Provider.of<UserDataService>(context, listen: false);
        // Log in as admin
        userDataService.login(role: 'admin');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminEntryPoint()),
        );
      } else {
        // Invalid password - specifically for non-admin attempts
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Access Denied'),
              content: const Text("This page is for administrators only. Please use the user login page if you are not an admin."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Go to User Login'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    Navigator.pushReplacementNamed(context, userLoginScreenRoute); // Navigate back to user login
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Authentication"),
        automaticallyImplyLeading: false, // Hide default back button
      ),
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
                    Text("Admin Access Required", style: Theme.of(context).textTheme.headlineSmall),
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
                      child: const Text("Login as Admin"),
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