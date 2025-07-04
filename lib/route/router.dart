import 'package:gas_com/screens/login/views/password_screen.dart';
import 'package:flutter/material.dart';
import '../entry_point.dart';
import '../models/product_model.dart';
import '../route/route_constants.dart';
import '../screens/checkout/views/cart_screen.dart';
import '../screens/checkout/views/thanks_for_order_screen.dart';
import '../screens/onbording/views/onbording_screnn.dart';
import '../screens/product/views/grouped_product_detail_screen.dart';
import '../screens/profile/views/faq_screen.dart';
import '../screens/profile/views/safety_tips_and_guides_screen.dart';
import 'package:gas_com/screens/profile/views/support_contacts.dart';
import 'package:gas_com/screens/profile/views/my_addresses_screen.dart';
import 'package:gas_com/screens/profile/views/my_orders_screen.dart';
import 'package:gas_com/screens/profile/views/edit_profile_screen.dart';
import 'package:gas_com/screens/checkout/views/set_credentials_screen.dart';
import 'package:gas_com/screens/login/views/user_login_screen.dart';
import 'package:gas_com/screens/admin/views/admin_order_details_screen.dart';
import 'package:gas_com/models/order_model.dart';
import 'package:gas_com/screens/login/views/admin_auth_screen.dart'; // Import the AdminAuthScreen

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(builder: (_) => const OnBordingScreen());

    case passwordScreenRoute:
      return MaterialPageRoute(builder: (_) => const PasswordScreen());

    case userLoginScreenRoute:
      return MaterialPageRoute(builder: (_) => const UserLoginScreen());

    case setCredentialsScreenRoute:
      return MaterialPageRoute(builder: (_) => const SetCredentialsScreen());

    // New route for Admin Authentication Screen
    case adminAuthScreenRoute:
      return MaterialPageRoute(builder: (_) => const AdminAuthScreen());

    case entryPointScreenRoute:
      return MaterialPageRoute(builder: (_) => const EntryPoint());

    case groupedProductDetailsScreenRoute:
      if (settings.arguments is GroupedProduct) {
        final groupedProduct = settings.arguments as GroupedProduct;
        return MaterialPageRoute(
          builder: (_) =>
              GroupedProductDetailScreen(groupedProduct: groupedProduct),
        );
      }
      return MaterialPageRoute(builder: (_) => const EntryPoint());

    case cartScreenRoute:
      return MaterialPageRoute(builder: (_) => const CartScreen());

    case thanksForOrderScreenRoute:
      if (settings.arguments is double) {
        final amount = settings.arguments as double;
        return MaterialPageRoute(
          builder: (_) => ThanksForOrderScreen(amount: amount, arguments: settings.arguments),
        );
      }
      return MaterialPageRoute(builder: (_) => const EntryPoint());

    case myOrdersScreenRoute:
      return MaterialPageRoute(builder: (_) => const MyOrdersScreen());

    case myAddressesScreenRoute:
      return MaterialPageRoute(builder: (_) => const MyAddressesScreen());

    case editProfileScreenRoute:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());

    case faqScreenRoute:
      return MaterialPageRoute(builder: (_) => const FaqScreen());

    case safetyTipsAndGuidesScreenRoute:
      return MaterialPageRoute(builder: (_) => const SafetyTipsAndGuidesScreen());

    case supportContactsRoute:
      return MaterialPageRoute(builder: (_) => const SupportContacts());

    case adminOrderDetailsScreenRoute:
      if (settings.arguments is OrderModel) {
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => AdminOrderDetailsScreen(order: order),
        );
      }
      return MaterialPageRoute(builder: (_) => const EntryPoint());


    default:
      return MaterialPageRoute(builder: (_) => const EntryPoint());
  }
}