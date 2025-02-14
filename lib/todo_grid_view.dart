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
      int length = prefs.getInt('todo_length') ?? 0;
      _controllers.clear();
      _checks.clear();
      for (int i = 0; i < length; i++) {
        _controllers
            .add(TextEditingController(text: prefs.getString('todo_$i') ?? ''));
        _checks.add(prefs.getBool('check_$i') ?? false);
      }
    });
  }

  void _saveTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('todo_length', _controllers.length);
    for (int i = 0; i < _controllers.length; i++) {
      await prefs.setString('todo_$i', _controllers[i].text);
      await prefs.setBool('check_$i', _checks[i]);
    }
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
      if (isCheck) {
        for (int i = 0; i < _controllers.length; i++) {
          _checks[i] = true;
        }
      } else {
        for (int i = 0; i < _controllers.length; i++) {
          _checks[i] = false;
        }
        _saveTodos();
      }
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
                  color: Colors.blue,
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      maxLines: 2,
                      onChanged: (value) {
                        _saveTodos();
                      },
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
