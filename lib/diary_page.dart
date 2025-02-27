// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'fortune_page.dart';
// import 'todo_grid_page.dart';

// class DiaryPage extends StatefulWidget {
//   const DiaryPage({super.key});

//   @override
//   State<DiaryPage> createState() => _DiaryPage();
// }

// class _DiaryPage extends State<DiaryPage> {
//   final List<TextEditingController> _controllers = [];

//   int _selectedIndex = 1;

//   late final List<Widget> _pages = [
//     const TodoGridPage(),
//     _buildDiaryPage(),
//     const FortunePage(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadDiary();
//   }

//   void _loadDiary() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       String? todoListJson = prefs.getString('diary_list');
//       if (todoListJson != null) {
//         List<dynamic> diaryList = jsonDecode(todoListJson);
//         _controllers.clear();
//         for (var item in diaryList) {
//           _controllers.add(TextEditingController(text: item['index']));
//         }
//       }
//     });
//   }

//   void _saveDiary() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<Map<String, dynamic>> diaryList = [];
//     for (int i = 0; i < _controllers.length; i++) {
//       diaryList.add({
//         'index': _controllers[i].text,
//       });
//     }
//     String todoListJson = jsonEncode(diaryList);
//     await prefs.setString('diary_list', todoListJson);
//   }

//   void _addDiary() {
//     setState(() {
//       _controllers.add(TextEditingController());

//       _saveDiary();
//     });
//   }

//   void _deleteDiary() {
//     setState(() {
//       for (int i = _controllers.length - 1; i >= 0; i--) {
//         _controllers.removeAt(i);
//       }
//       _saveDiary();
//     });
//   }

//   void _bottomBarNavigation(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Widget _buildDiaryPage() {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('할 일 목록'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: _deleteDiary,
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _addDiary,
//           ),
//         ],
//       ),
//       body: Scrollbar(
//         thickness: 5,
//         thumbVisibility: false,
//         radius: const Radius.circular(5),
//         child: GridView.builder(
//           scrollDirection: Axis.vertical,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: _controllers.length,
//           itemBuilder: (context, index) {
//             return Stack(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                     child: TextField(
//                       controller: _controllers[index],
//                       maxLines: 2,
//                       onChanged: (value) {
//                         _saveDiary();
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//               icon: Icon(_selectedIndex == 0
//                   ? Icons.check_circle
//                   : Icons.check_circle_outline),
//               label: 'Todo'),
//           BottomNavigationBarItem(
//               icon: Icon(_selectedIndex == 1
//                   ? Icons.edit_note
//                   : Icons.edit_note_outlined),
//               label: 'Diary'),
//           BottomNavigationBarItem(
//               icon: Icon(_selectedIndex == 2
//                   ? Icons.star_purple500
//                   : Icons.star_border_purple500_outlined),
//               label: 'Fortune'),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _bottomBarNavigation,
//       ),
//     );
//   }
// }
