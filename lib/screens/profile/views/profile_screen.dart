import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/route/route_constants.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/screens/login/views/splash_screen.dart'; // <--- ADD THIS LINE

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Consumer<UserDataService>(
        builder: (context, userDataService, child) {
          final userName = userDataService.userName ?? "Guest User";
          final userContact = userDataService.userContact ?? "N/A";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                // User Info Card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: primaryColor,
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: defaultPadding),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userContact,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),

                // Profile Options List
                _buildProfileOption(
                  context,
                  icon: Icons.edit_outlined,
                  title: "Edit Profile",
                  onTap: () {
                    // Navigate to Edit Profile Screen
                    Navigator.pushNamed(context, editProfileScreenRoute);
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: "My Orders",
                  onTap: () {
                    // Navigate to My Orders Screen
                    Navigator.pushNamed(context, myOrdersScreenRoute);
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.location_on_outlined,
                  title: "My Addresses",
                  onTap: () {
                    // Navigate to My Addresses Screen
                    Navigator.pushNamed(context, myAddressesScreenRoute);
                  },
                ),
                const Divider(height: defaultPadding * 2), // Separator

                // Help Center Options
                // _buildProfileOption(
                 // context,
                 // icon: Icons.help_outline,
                 // title: "Help Center",
                 // onTap: () {
                    // Navigate to Help Center Screen
                   // Navigator.pushNamed(context, helpCenterScreenRoute);
                 // },
               // ),
                _buildProfileOption(
                  context,
                  icon: Icons.question_answer_outlined,
                  title: "FAQ",
                  onTap: () {
                    // Navigate to FAQ Screen
                    Navigator.pushNamed(context, faqScreenRoute);
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.safety_check_outlined,
                  title: "Safety Tips & Guides",
                  onTap: () {
                    // Navigate to Safety Tips & Guides Screen
                    Navigator.pushNamed(context, safetyTipsAndGuidesScreenRoute);
                  },
                ),
                _buildProfileOption(
                  context,
                  icon: Icons.contact_phone_outlined,
                  title: "Support Contacts",
                  onTap: () {
                    // Navigate to Support Contacts Screen
                    Navigator.pushNamed(context, supportContactsRoute);
                  },
                ),
                const Divider(height: defaultPadding * 2), // Separator

                // Logout Button
                ListTile(
                  leading: const Icon(Icons.logout, color: errorColor),
                  title: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: errorColor),
                  ),
                  onTap: () {
                    // Implement logout logic
                    userDataService.logout();
                    // Example: Navigate back to login/splash screen
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SplashScreen()), // Assuming SplashScreen handles initial routing
                      (route) => false, // Remove all previous routes
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      margin: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 18),
        onTap: onTap,
      ),
    );
  }
}
