import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoGridView extends StatefulWidget {
  const TodoGridView({super.key});

  @override
  State<TodoGridView> createState() => _TodoGridView();
}

class _TodoGridView extends State<TodoGridView> {
  final List<TextEditingController> _controllers =
      List.generate(1, (index) => TextEditingController());
  int _selectedIndex = -1;
  bool _showDeleteButton = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].text = prefs.getString('todo_$i') ?? '';
      }
    });
  }

  void _saveTodo(int index, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('todo_$index', value);
  }

  void _addTodo() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _deleteTodo() {
    setState(() {
      if (_selectedIndex >= 0 && _selectedIndex < _controllers.length) {
        _controllers.removeAt(_selectedIndex);
        _showDeleteButton = false;
        _selectedIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: [
          if (_showDeleteButton)
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
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  _showDeleteButton = true;
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue,
                child: Center(
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: '할 일 $index',
                    ),
                    onChanged: (value) {
                      _saveTodo(index, value);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
