import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoServices {
  static const String baseUrl = "https://crud-backend-6t6r.onrender.com/api";

  //Get all data
  static Future<List<dynamic>> getTodos() async {
    final responce = await http.get(Uri.parse("$baseUrl/get"));
    if (responce.statusCode == 200) {
      return json.decode(responce.body);
    } else {
      throw Exception("Failed to load todos");
    }
  }

  //create todos
  static Future<dynamic> createTodo(String title, String desc) async {
    final responce = await http.post(Uri.parse("$baseUrl/post"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'description': desc}));
    if (responce.statusCode == 201) {
      return json.decode(responce.body);
    } else {
      throw Exception("failed to create todo");
    }
  }

  //update todo
  static Future<dynamic> updatetodo(
      String id, String title, String desc) async {
    final responce = await http.put(Uri.parse("$baseUrl/update/$id"),
        headers: {'Content-type': 'application/json'},
        body: json.encode({'title': title, 'description': desc}));
    if (responce.statusCode == 200) {
      return json.decode(responce.body);
    } else {
      throw Exception("Failed to update todo");
    }
  }

  //delete todo
  static Future<dynamic> deleteTodo(String id) async {
    final responce = await http.delete(Uri.parse("$baseUrl/delete/$id"));
    if (responce.statusCode != 200) {
      throw Exception("Failed to delete Todo");
    }
  }
}
