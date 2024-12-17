import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(const CMSPage());

class CMSPage extends StatefulWidget {
  const CMSPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller CMS',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CMSPage(),
    );
  }
  _CMSPageState createState() => _CMSPageState();
}

class _CMSPageState extends State<CMSPage> {
  TextEditingController storenameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  List<dynamic> posts = [];
  List<dynamic> publishedPosts = [];

  // Fetch posts and published posts
  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('https://autolink.fun/get_posts.php'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
      });
    }
  }

  // Fetch published posts
  Future<void> fetchPublishedPosts() async {
    final response = await http.get(Uri.parse('https://autolink.fun/get_published_posts.php'));
    if (response.statusCode == 200) {
      setState(() {
        publishedPosts = json.decode(response.body);
      });
    }
  }

  // Create a post
  Future<void> createPost() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://autolink.fun/create_post.php'),
    );
    request.fields['storename'] = storenameController.text;
    request.fields['title'] = titleController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['price'] = priceController.text;
    request.fields['tag'] = tagController.text;
    request.fields['address'] = addressController.text;

    // Add image if provided
    if (imageController.text.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('img', imageController.text);
      request.files.add(imageFile);
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      fetchPosts(); // Refresh posts after creating a new post
    }
  }

  // Delete a post
  Future<void> deletePost(int postId) async {
    final response = await http.post(
      Uri.parse('https://autolink.fun/delete_post.php'),
      body: {'delete_id': postId.toString()},
    );
    if (response.statusCode == 200) {
      fetchPosts(); // Refresh posts after deleting
    }
  }

  // Publish a post
  Future<void> publishPost(int postId) async {
    final response = await http.post(
      Uri.parse('https://autolink.fun/publish_post.php'),
      body: {'post_id': postId.toString()},
    );
    if (response.statusCode == 200) {
      fetchPosts(); // Refresh posts after publishing
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchPublishedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller CMS'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: storenameController,
                    decoration: InputDecoration(labelText: 'Store Name'),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 4,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(labelText: 'Tags'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(labelText: 'Image Path'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: createPost,
                    child: Text('Create Post'),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Posts', style: TextStyle(fontSize: 18)),
                  ...posts.map((post) {
                    return Card(
                      child: ListTile(
                        title: Text(post['title']),
                        subtitle: Text(post['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.publish),
                              onPressed: () => publishPost(post['id']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deletePost(post['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Published Posts', style: TextStyle(fontSize: 18)),
                  ...publishedPosts.map((post) {
                    return Card(
                      child: ListTile(
                        title: Text(post['title']),
                        subtitle: Text(post['description']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deletePost(post['id']),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
