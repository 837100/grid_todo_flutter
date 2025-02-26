import 'package:flutter/material.dart';

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page: Settings'),
      ),
      body: const Center(
        child: Text('일기장 페이지 입니다.'),
      ),
    );
  }
}
