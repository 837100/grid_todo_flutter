import 'package:flutter/material.dart';



class TodoGridView extends StatelessWidget {
  const TodoGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일'),
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
