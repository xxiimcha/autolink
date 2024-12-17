import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
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
