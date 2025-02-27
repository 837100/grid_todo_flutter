import 'package:flutter/material.dart';
import 'diary_page.dart';
import 'fortune_page.dart';
import 'todo_grid_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Grid App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TodoGridPage(),
    Scaffold(body: Center(child: Text('일기장'))),
    FortunePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0
                  ? Icons.check_circle
                  : Icons.check_circle_outline),
              label: 'Todo'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1
                  ? Icons.edit_note
                  : Icons.edit_note_outlined),
              label: 'Diary'),
          BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2
                  ? Icons.star_purple500
                  : Icons.star_border_purple500_outlined),
              label: 'Fortune'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
