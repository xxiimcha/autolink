import 'package:flutter/material.dart';
import 'Screens/cart.dart';
import 'Screens/login.dart';
import 'Screens/shop.dart';
import 'Screens/user_details.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPage(),
  '/cart': (context) => const CartPage(),
  '/cms': (context) => const CMSPage(), // CMS Page route
  '/shop': (context) => const ShopPage(),
  '/account': (context) => const UserDetailsPage(),
};
