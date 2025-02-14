import 'package:flutter/material.dart';


class TodoAddView extends StatelessWidget {
  const TodoAddView({Key? key});

  @override
  Widget build(BuildContext context) {
    return TextFieldExample();
  }
}

class TextFieldExample extends StatefulWidget {
  const TextFieldExample({super.key});

  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Field Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your username',
              ),
            ),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Enter your password',
                ),
                obscureText: true),
            // 클릭 시 AlertDialog를 표시하는 버튼
            ElevatedButton(
              onPressed: () {
                // AlertDialog를 표시하는 버튼.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Text Field Value'),
                      content:
                          Text('The value you entered is: ${_controller.text}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Show Value'),
            ),
          ],
        ),
      ),
    );
  }
}
