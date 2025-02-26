import 'package:flutter/material.dart';

class FortunePage extends StatelessWidget {
  const FortunePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 운세'),
      ),
      body: const Center(
        child: Text('Forturne Page'),
      ),
    );
  }
}
