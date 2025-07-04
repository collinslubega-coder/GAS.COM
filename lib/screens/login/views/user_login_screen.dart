import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/entry_point.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gas_com/route/route_constants.dart'; // Import route constants

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final userDataService = Provider.of<UserDataService>(context, listen: false);
      final bool loginSuccess = await userDataService.loginWithCredentials(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EntryPoint()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid username or password")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Login"), // Changed title for clarity
        automaticallyImplyLeading: false, // Keep consistent if no back button desired
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined), // Admin icon
            tooltip: "Admin Access",
            onPressed: () {
              // Navigate to the Admin Authentication Screen
              Navigator.pushNamed(context, adminAuthScreenRoute); //
            },
          ),
        ],
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
                    Image.asset(
                      "assets/logo/logo.png",
                      height: 120,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: defaultPadding),
                    const Text(
                      "Login to your account to continue shopping.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    TextFormField(
                      controller: _usernameController,
                      validator: RequiredValidator(errorText: 'Username is required'),
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Enter your username",
                      ),
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _passwordController,
                      validator: RequiredValidator(errorText: 'Password is required'),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
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