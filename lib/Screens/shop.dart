import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'checkout.dart';

void main() => runApp(const AutoLinkShop());

class AutoLinkShop extends StatelessWidget {
  const AutoLinkShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoLink Shop',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const ShopPage(),
    );
  }
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<dynamic> publishedPosts = [];
  bool isLoading = true;
  final String domain = 'https://autolink.fun'; // Your domain
  final List<dynamic> cart = []; // Store cart items

  @override
  void initState() {
    super.initState();
    _fetchPublishedPosts();
  }

  Future<void> _fetchPublishedPosts() async {
    final url = '$domain/scripts/post.php?action=get_post';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          publishedPosts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

 void _addToCart(dynamic product) async {
    final url = '$domain/scripts/cart.php?action=add_to_cart';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_email': 'user@example.com', // Replace with the logged-in user's email
          'post_id': product['id'].toString(),
          'title': product['title'],
          'description': product['description'],
          'price': product['price'].toString(),
          'img': product['img'],
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product['title']} added to cart')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add to cart: ${responseData['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server error: Failed to add to cart')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error: Failed to add to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoLink Shop'),
        backgroundColor: const Color(0xFF2A2D33),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              _showCart();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: publishedPosts.length,
                itemBuilder: (ctx, index) {
                  final post = publishedPosts[index];
                  final imageUrl = '$domain/${post['img']}'; // Concatenate domain to image path
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Price: \$${post['price']}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post['tag'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _addToCart(post);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Add to Cart'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsPage(product: post, imageUrl: imageUrl),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text('View'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 5;
    if (screenWidth > 800) return 3;
    return 2;
  }

  void _showCart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cart'),
        content: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(cart[index]['title']),
                subtitle: Text('Price: \$${cart[index]['price']}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
class ProductDetailsPage extends StatelessWidget {
  final dynamic product;
  final String imageUrl;

  const ProductDetailsPage({super.key, required this.product, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']),
        backgroundColor: const Color(0xFF2A2D33),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              product['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${product['price']}',
              style: const TextStyle(fontSize: 20, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Tags: ${product['tag']}'),
            const SizedBox(height: 8),
            Text('Address: ${product['address']}'),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final url = 'https://autolink.fun/scripts/cart.php?action=add_to_cart';
                  try {
                    // Add to cart first
                    final response = await http.post(
                      Uri.parse(url),
                      body: {
                        'user_email': 'user@example.com', // Replace with the logged-in user's email
                        'post_id': product['id'].toString(),
                        'title': product['title'],
                        'description': product['description'],
                        'price': product['price'].toString(),
                        'img': product['img'],
                      },
                    );

                    if (response.statusCode == 200) {
                      final responseData = json.decode(response.body);
                      if (responseData['status'] == 'success') {
                        // Navigate to Checkout Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(product: product),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to proceed: ${responseData['message']}')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Server error: Failed to proceed')),
                      );
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Network error: Failed to proceed')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Buy Now'),
              ),

          ],
        ),
      ),
    );
  }
}
