import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final dynamic product;

  const CheckoutPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF2A2D33),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Image.network(
                  product['img'],
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Product Title
              Text(
                product['title'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Product Price
              Text(
                'Price: \$${product['price']}',
                style: const TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Product Description
              Text(
                'Description:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Product Details
              Text(
                'Details:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Tags: ${product['tag']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Address: ${product['address']}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate back to the product list
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Simulate purchase confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Purchase completed!')),
                      );

                      // You can navigate to a confirmation page or reset the state here
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Confirm Purchase'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
