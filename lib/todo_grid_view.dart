import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoGridView extends StatefulWidget {
  const TodoGridView({super.key});

  @override
  State<TodoGridView> createState() => _TodoGridView();
}

class _TodoGridView extends State<TodoGridView> {
  final List<TextEditingController> _controllers = [];
  final List<bool> _checks = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? todoListJson = prefs.getString('todo_list');
      if (todoListJson != null) {
        List<dynamic> todoList = jsonDecode(todoListJson);
        _controllers.clear();
        _checks.clear();
        for (var item in todoList) {
          _controllers.add(TextEditingController(text: item['index']));
          _checks.add(item['check']);
        }
      }
    });
  }

  void _saveTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> todoList = [];
    for (int i = 0; i < _controllers.length; i++) {
      todoList.add({
        'index': _controllers[i].text,
        'check': _checks[i],
      });
    }
    String todoListJson = jsonEncode(todoList);
    await prefs.setString('todo_list', todoListJson);
  }

  void _addTodo() {
    setState(() {
      _controllers.add(TextEditingController());
      _checks.add(false);
      _saveTodos();
    });
  }

  void _deleteTodo() {
    setState(() {
      for (int i = _controllers.length - 1; i >= 0; i--) {
        if (_checks[i] == true) {
          _controllers.removeAt(i);
          _checks.removeAt(i);
        }
      }
      _saveTodos();
    });
  }

  void _checkAll(bool isCheck) {
    setState(() {
      for (int i = 0; i < _controllers.length; i++) {
        _checks[i] = isCheck;
      }
      _saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_box_outline_blank),
            onPressed: () => _checkAll(false),
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () => _checkAll(true),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTodo,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTodo,
          ),
        ],
      ),
      body: Scrollbar(
        thickness: 5,
        thumbVisibility: false,
        radius: const Radius.circular(5),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: _checks[index] ? Colors.grey : Colors.blue,
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      maxLines: 2,
                      onChanged: (value) {
                        _saveTodos();
                      },
                      style: TextStyle(
                        fontSize: 18.0,
                        decoration: _checks[index]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: _checks[index],
                    onChanged: (newValue) {
                      setState(() {
                        _checks[index] = newValue!;
                        _saveTodos();
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
