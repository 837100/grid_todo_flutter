import 'package:flutter/material.dart';

class TodoGridView extends StatelessWidget {
  const TodoGridView({super.key});

  void _addTodo() {
    // 할 일 추가 로직을 여기에 작성하세요.
    debugPrint('Add Todo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addTodo,
          )
        ]
      ),
      body: Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(5),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                debugPrint('Item $index Tapped');
              },
              child: Container(
                color: Colors.blue[100 * (index % 9)],
                child: Center(
                  child: Text('Item $index'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
