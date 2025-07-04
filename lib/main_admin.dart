import 'package:flutter/material.dart';
import 'package:gas_com/screens/login/views/splash_screen.dart';
import 'package:gas_com/services/bookmark_service.dart';
import 'package:gas_com/services/cart_service.dart';
import 'package:gas_com/services/user_data_service.dart';
import 'package:gas_com/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:gas_com/route/router.dart'; // Import your router file
import 'package:gas_com/route/route_constants.dart'; // Import your route constants

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataService()),
        ChangeNotifierProvider(create: (context) => BookmarkService()),
        ChangeNotifierProvider(create: (context) => CartService()),
      ],
      child: const AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAS.COM - Admin',
      theme: AppTheme.darkTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.dark,
      // REMOVED 'home' property
      // home: const SplashScreen(), // Old line

      // Use onGenerateRoute to handle all named routes
      initialRoute: onbordingScreenRoute, // Or your specific admin initial route
      onGenerateRoute: generateRoute, // Point to your generateRoute function
    );
  }
}
