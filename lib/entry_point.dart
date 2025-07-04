import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gas_com/constants.dart';
import 'package:gas_com/screens/bookmark/views/bookmark_screen.dart';
import 'package:gas_com/screens/checkout/views/cart_screen.dart';
import 'package:gas_com/screens/home/views/home_screen.dart';
import 'package:gas_com/screens/profile/views/profile_screen.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    BookmarkScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          // Home Icon
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Bookmark Icon
          const BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          // **THE FIX IS HERE:**
          // The cart icon is now your custom "gas_cooker.svg".
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/gas_cooker.svg",
              height: 24, // Matches the standard icon size
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/gas_cooker.svg",
              height: 24, // Matches the standard icon size
              colorFilter: const ColorFilter.mode(
                primaryColor, // Uses the primary "fiery blue" color when active
                BlendMode.srcIn,
              ),
            ),
            label: 'Kitchen',
          ),
          // Profile Icon
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}