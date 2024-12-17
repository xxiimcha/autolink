import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Screens/cart.dart';
import 'Screens/login.dart';
import 'Screens/shop.dart';
import 'Screens/user_details.dart';


void main() {
  runApp(const AutoLinkApp());
}

class AutoLinkApp extends StatelessWidget {
  const AutoLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLink - Automotive Services',
      theme: ThemeData(
        primaryColor: const Color(0xFFF27A21),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: const AutoLinkHomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/cart': (context) => const CartPage(),
        '/cms': (context) => const CMSPage(), // Or CmsScreen after renaming
        '/shop': (context) => const ShopPage(),
        '/account': (context) => const UserDetailsPage(),
      },
    );
  }
}

class SessionManager {
  final String baseUrl = 'https://autolink.fun/AppOP/session_manager.php';

  Future<Map<String, dynamic>> checkSession() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to get session data'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }
}

class AutoLinkHomePage extends StatefulWidget {
  const AutoLinkHomePage({super.key});

  @override
  _AutoLinkHomePageState createState() => _AutoLinkHomePageState();
}

class _AutoLinkHomePageState extends State<AutoLinkHomePage> {
  late Future<Map<String, dynamic>> sessionData;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    sessionData = SessionManager().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2D33),
        title: const Text(
          'AutoLink',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: sessionData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data?['status'] == 'error') {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFF27A21),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'AutoLink',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Automotive Services Hub',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'CMS',
              onTap: () {
                Navigator.pushNamed(context, '/cms');
              },
            ),
            _buildDrawerItem(
              icon: Icons.account_circle,
              text: 'Account',
              onTap: () {
                Navigator.pushNamed(context, '/account');
              },
            ),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Cart',
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            _buildDrawerItem(
              icon: Icons.store,
              text: 'Shop',
              onTap: () {
                Navigator.pushNamed(context, '/shop');
              },
            ),
            const Spacer(),
            const Divider(),
            FutureBuilder<Map<String, dynamic>>(
              future: sessionData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data?['status'] == 'error') {
                  return _buildDrawerItem(
                    icon: Icons.login,
                    text: 'Login',
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  );
                } else {
                  return _buildDrawerItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () {
                      // Perform logout logic and redirect
                      Navigator.pushNamed(context, '/login');
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.all(20),
              height: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'AutoLink',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF27A21),
                    ),
                  ),
                  const Text(
                    'Find and support Local Shops for Your Automotive Needs\nShop Local Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF27A21),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Explore',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            // Other sections...
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2A2D33),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            '© 2024 AutoLink. All Rights Reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFF27A21)),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
