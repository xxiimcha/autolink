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
      title: 'Seller Registration',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const SellerRegistrationPage(),
    );
  }
}

class SellerRegistrationPage extends StatefulWidget {
  const SellerRegistrationPage({super.key});

  @override
  _SellerRegistrationPageState createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController storenameController = TextEditingController();

  List<String> offerings = [];
  String? successMessage;
  String? errorMessage;

  // Function to handle form submission
  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://autolink.fun/Reg_config.php'),
        body: {
          'firstname': firstnameController.text,
          'lastname': lastnameController.text,
          'storename': storenameController.text,
          'offerings': offerings.join(','), // send offerings as a comma-separated string
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            successMessage = data['message'];
            errorMessage = null;
          });
        } else {
          setState(() {
            errorMessage = data['message'];
            successMessage = null;
          });
        }
      } else {
        setState(() {
          errorMessage = "Something went wrong. Please try again later.";
          successMessage = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seller Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Show error message if any
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                // Show success message if any
                if (successMessage != null)
                  Text(
                    successMessage!,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: firstnameController,
                        decoration: const InputDecoration(labelText: 'First Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: lastnameController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: storenameController,
                        decoration: const InputDecoration(labelText: 'Store Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your store name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Checkboxes for offerings
                      Column(
                        children: [
                          const Text('Select Offerings:', style: TextStyle(fontSize: 16)),
                          CheckboxListTile(
                            title: const Text('Parts'),
                            value: offerings.contains('Parts'),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  offerings.add('Parts');
                                } else {
                                  offerings.remove('Parts');
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Repair'),
                            value: offerings.contains('Repair'),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  offerings.add('Repair');
                                } else {
                                  offerings.remove('Repair');
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Washing'),
                            value: offerings.contains('Washing'),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  offerings.add('Washing');
                                } else {
                                  offerings.remove('Washing');
                                }
                              });
                            },
                          ),
                          CheckboxListTile(
                            title: const Text('Towing'),
                            value: offerings.contains('Towing'),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  offerings.add('Towing');
                                } else {
                                  offerings.remove('Towing');
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Register Button
                      ElevatedButton(
                        onPressed: submitForm,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: const Color(0xFFF27A21), padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Register as Seller'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
