import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPage();
}

class _DiaryPage extends State<DiaryPage> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  void _loadDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String? todoListJson = prefs.getString('diary_list');
      if (todoListJson != null) {
        List<dynamic> diaryList = jsonDecode(todoListJson);
        _controllers.clear();
        for (var item in diaryList) {
          _controllers.add(TextEditingController(text: item['index']));
        }
      }
    });
  }

  void _saveDiary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> diaryList = [];
    for (int i = 0; i < _controllers.length; i++) {
      diaryList.add({
        'index': _controllers[i].text,
      });
    }
    String todoListJson = jsonEncode(diaryList);
    await prefs.setString('diary_list', todoListJson);
  }

  void _addDiary() {
    setState(() {
      _controllers.add(TextEditingController());

      _saveDiary();
    });
  }

  void _deleteDiary() {
    setState(() {
      for (int i = _controllers.length - 1; i >= 0; i--) {
        _controllers.removeAt(i);
      }
      _saveDiary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 목록'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteDiary,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addDiary,
          ),
        ],
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    controller: _controllers[index],
                    maxLines: 2,
                    onChanged: (value) {
                      _saveDiary();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
