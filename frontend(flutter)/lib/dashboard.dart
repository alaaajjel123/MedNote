import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List<dynamic>? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    getTodoList();
  }

  Future<void> addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "description": _todoDesc.text
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        _todoTitle.clear();
        _todoDesc.clear();
        Navigator.pop(context);
        getTodoList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong")),
        );
      }
    }
  }

  Future<void> getTodoList() async {
    var response = await http.post(Uri.parse(getToDoList),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      setState(() {
        items = jsonResponse['success'];
      });
    }
  }

  Future<void> deleteItem(String id) async {
    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id}));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getTodoList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.list, color: Colors.white, size: 30),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, $userId",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "${items?.length ?? 0} Tasks",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: items == null
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: items!.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(items![index]['_id']),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                onPressed: (_) =>
                                    deleteItem(items![index]['_id']),
                              ),
                            ],
                          ),
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading:
                                  Icon(Icons.task, color: Colors.blueAccent),
                              title: Text(items![index]['title'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(items![index]['description']),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title:
              Text('Add To-Do', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoTitle,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _todoDesc,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: addTodo,
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
