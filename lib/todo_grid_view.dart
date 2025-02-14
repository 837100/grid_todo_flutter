import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoGridView extends StatefulWidget {
  const TodoGridView({super.key});

  @override
  State<TodoGridView> createState() => _TodoGridView();
}

class _TodoGridView extends State<TodoGridView> {
  final List<TextEditingController> _controllers =
      List.generate(30, (index) => TextEditingController());
  final List<bool> _checks = List.generate(30, (index) => false);

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int length = prefs.getInt('todo_length') ?? 0;
      for (int i = 0; i < length; i++) {
        _controllers[i].text = prefs.getString('todo_$i') ?? '';
        _checks[i] = prefs.getBool('check_$i') ?? false;
      }
    });
  }

  void _saveTodo(int index, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('todo_$index', value);
    _loadTodos();
  }

  void _saveCheck(int index, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('check_$index', value.toString());
    _loadTodos();
  }

  void _addTodo() {
    setState(() {
      if (_controllers.length < 30) {
        _controllers.add(TextEditingController());
        _checks.add(false);
      }
    });
  }

  void _deleteTodo() {
    setState(() {
      for (int i = _controllers.length - 1; i >= 0; i--) {
        if (_checks[i] == true) {
          _controllers.removeAt(i);
          _checks.removeAt(i);
        } else {
          _saveTodo(i, _controllers[i].toString());
          _saveCheck(i, _checks[i]);
          continue;
        }
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
                        _saveTodo(index, value);
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
                        debugPrint(index.toString());
                        debugPrint(newValue.toString());
                        _checks[index] = newValue!;
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
