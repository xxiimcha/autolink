import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Details',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const UserDetailsPage(),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  TextEditingController emailRecoveryController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController contact1Controller = TextEditingController();
  TextEditingController contact2Controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> userDetails = {};
  bool isSeller = false; // Check if the user is a seller

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    // Simulate fetching user details from an API
    final response = await http.get(Uri.parse('https://yourdomain.com/get_user_details.php'));

    if (response.statusCode == 200) {
      setState(() {
        userDetails = json.decode(response.body);
        emailRecoveryController.text = userDetails['email_recovery'] ?? '';
        usernameController.text = userDetails['username'] ?? '';
        contact1Controller.text = userDetails['contact1'] ?? '';
        contact2Controller.text = userDetails['contact2'] ?? '';
      });
    }
  }

  Future<void> updateUserDetails() async {
    final response = await http.post(
      Uri.parse('https://yourdomain.com/update_user_details.php'),
      body: {
        'email_recovery': emailRecoveryController.text,
        'username': usernameController.text,
        'contact1': contact1Controller.text,
        'contact2': contact2Controller.text,
        'password': passwordController.text.isNotEmpty ? passwordController.text : '',
      },
    );

    if (response.statusCode == 200) {
      // Successfully updated
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('User details updated successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error handling
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to update user details.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> checkSellerStatus() async {
    final response = await http.get(Uri.parse('https://yourdomain.com/check_seller_status.php'));

    if (response.statusCode == 200) {
      setState(() {
        isSeller = json.decode(response.body)['is_seller'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form to display and update user details
            const Text('User Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: TextEditingController(text: userDetails['email'] ?? ''),
              decoration: const InputDecoration(labelText: 'Email (Permanent)', enabled: false),
            ),
            TextFormField(
              controller: emailRecoveryController,
              decoration: const InputDecoration(labelText: 'Email Recovery'),
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password', hintText: 'Leave blank to keep current'),
              obscureText: true,
            ),
            TextFormField(
              controller: contact1Controller,
              decoration: const InputDecoration(labelText: 'Contact #1'),
            ),
            TextFormField(
              controller: contact2Controller,
              decoration: const InputDecoration(labelText: 'Contact #2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUserDetails,
              child: const Text('Save'),
            ),
            const SizedBox(height: 20),
            // Seller registration section
            const Text('Become a Seller, Offer products or Services!', style: TextStyle(fontSize: 18)),
            if (isSeller) ...[
              // If the user is a seller, show the CMS dashboard button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CMSPage()), // Link to your CMS dashboard page
                  );
                },
                child: const Text('Go to CMS Dashboard'),
              ),
            ] else ...[
              // If the user is not a seller, show the register button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterSellerPage()), // Link to your seller registration page
                  );
                },
                child: const Text('Register as Seller'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CMSPage extends StatelessWidget {
  const CMSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the CMS Dashboard'),
      ),
    );
  }
}

class RegisterSellerPage extends StatelessWidget {
  const RegisterSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Registration'),
      ),
      body: const Center(
        child: Text('Register to become a seller'),
      ),
    );
  }
}
