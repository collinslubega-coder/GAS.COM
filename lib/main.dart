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
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAS.COM',
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.system,
      // REMOVED 'home' property
      // home: const SplashScreen(), // Old line

      // Use onGenerateRoute to handle all named routes
      initialRoute: onbordingScreenRoute, // Or whatever your desired initial route is
      onGenerateRoute: generateRoute, // Point to your generateRoute function
    );
  }
}
