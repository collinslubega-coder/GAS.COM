import 'package:flutter/material.dart';
import 'package:gas_com/admin_entry_point.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/entry_point.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/route/route_constants.dart'; // Import route constants

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // The "keys" to the different floors of our app
  final String _adminPassword = "gasA@25";
  final String _userPassword = "gasU@25";

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async { // Made async to await userDataService.initialized
    if (_formKey.currentState!.validate()) {
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      final enteredPassword = _passwordController.text;

      // Ensure userDataService is initialized before checking credentials
      await userDataService.initialized; //

      if (enteredPassword == _adminPassword) {
        // Log in as admin and go to the Admin floor
        userDataService.login(role: 'admin'); //
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminEntryPoint()),
        );
      } else if (enteredPassword == _userPassword) {
        // Log in as customer
        userDataService.login(role: 'customer'); //

        // Check if user has already set up custom username/password credentials
        if (userDataService.hasSetCredentials) { //
          // If credentials exist, direct them to the UserLoginScreen
          Navigator.pushReplacementNamed(context, userLoginScreenRoute); //
        } else {
          // If no credentials yet, this is their first customer login, go to main EntryPoint
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EntryPoint()),
          );
        }
      } else {
        // Invalid key
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Authorization Code")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding), //
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Authorization Required", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: defaultPadding * 2), //
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an authorization code';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Authorization Code",
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 2), //
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Proceed"),
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