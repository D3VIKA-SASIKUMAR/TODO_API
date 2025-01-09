import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  List<dynamic> _works = [];
  bool isLoading = true;
  Future<void> _submitData() async {
    try {
      final response = await http.post(
        Uri.parse('https://crud-backend-6t6r.onrender.com/api/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _title.text,
          'description': _description.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data posted successfully!')),
        );

        _title.clear();
        _description.clear();

        await fetchData(); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post data: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('https://crud-backend-6t6r.onrender.com/api/get'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _works = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _works.isEmpty
              ? const Center(
                  child: Text(
                    'No data found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _works.length,
                  itemBuilder: (context, index) {
                    final todo = _works[index];
                    return Card(
                      color: const Color.fromARGB(255, 214, 213, 213),
                      margin: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo['title'] ?? 'No Title',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              todo['description'] ?? 'No Description',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 71, 70, 70)),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.edit,
                                size: 20,
                              )
                            ]),
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 74, 173),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _submitData();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
