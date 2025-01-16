import 'package:flutter/material.dart';
import 'package:todo_api/services.dart/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  List<dynamic> todo = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 88, 87, 132),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : todo.isEmpty
              ? const Center(
                  child: Text(
                    'No data fouend.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: todo.length,
                  itemBuilder: (context, index) {
                    final todos = todo[index];
                    return Card(
                        color: const Color.fromARGB(255, 48, 13, 152),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: ListTile(
                          minTileHeight: 100,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todos['title'] ?? 'No Title Found',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                todos['description'] ?? 'No Description',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                onPressed: () {
                                  _showAlertDialougeBox(todos['_id']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                onPressed: () {
                                  __editTodo(todos['_id'], todos['title'],
                                      todos['description']);
                                },
                              ),
                            ],
                          ),
                        ));
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
                  style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 74, 173)),
                  onPressed: () {
                    Navigator.pop(context);
                    _addTodo();
                  },
                  child:
                      const Text('Done', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void __editTodo(String id, String title, String desc) {
    _title.text = title;
    _description.text = desc;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Task'),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 74, 173)),
            onPressed: () {
              Navigator.pop(context);
              _updateTodo(id, _title.text, _description.text);
            },
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAlertDialougeBox(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to delete this task?'),
        content: Row(
          children: const [
            Text('Are you sure you want to delete this task?'),
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
              _deleteTodo(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> loadTodos() async {
    try {
      final loadedTodos = await TodoServices.getTodos();
      setState(() {
        todo = loadedTodos;
        isLoading = false;
      });
    } catch (e) {
      _showError("Failed to load todos");
    }
  }

  Future<void> _addTodo() async {
    // if (_todoController.text.isEmpty) return;

    try {
      await TodoServices.createTodo(_title.text, _description.text);
      _title.clear();
      _description.clear();
      await loadTodos();
    } catch (e) {
      _showError('Failed to add todo');
    }
  }

  Future<void> _updateTodo(String id, String title, String desc) async {
    try {
      await TodoServices.updatetodo(id, title, desc);
      await loadTodos();
    } catch (e) {
      _showError("Failed to update todo");
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await TodoServices.deleteTodo(id);
      await loadTodos();
    } catch (e) {
      _showError("Failed to delete todo");
    }
  }
}
