import 'package:flutter/material.dart';
import 'package:gas_com/admin_entry_point.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/entry_point.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/screens/login/views/user_login_screen.dart'; // Import the new user login screen


class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  // Removed _checkAuthAndNavigate from initState
  // @override
  // void initState() {
  //   super.initState();
  //   _checkAuthAndNavigate();
  // }

  void _handleGetStarted() async { // Renamed for clarity
    // Get the UserDataService instance
    final userDataService = Provider.of<UserDataService>(context, listen: false);

    // Wait until UserDataService has completed its initial loading from SharedPreferences
    await userDataService.initialized; //

    // After initialization, check the login status
    if (userDataService.isLoggedIn) { //
      if (userDataService.userRole == 'admin') { //
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminEntryPoint()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EntryPoint()),
          );
        }
      }
    } else {
      // If not logged in after initialization
      if (userDataService.hasSetCredentials) { //
        // If user has set credentials (username/password), go to UserLoginScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserLoginScreen()),
          );
        }
      } else {
        // If no credentials are set, go to the initial PasswordScreen (authorization code)
        if (mounted) {
          Navigator.pushReplacementNamed(context, passwordScreenRoute); //
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              "assets/images/banner_large.jpg",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 1.5),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    "Welcome to GAS.COM",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: defaultPadding),
                  const Text(
                    "Your one-stop GAS.COM for cooking gas and accessories, delivered to your kitchen.",
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    onPressed: _handleGetStarted, // Now explicitly called by the button
                    child: const Text("Get Started"),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}