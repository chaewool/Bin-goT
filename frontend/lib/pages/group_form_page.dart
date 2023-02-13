import 'package:flutter/material.dart';

class GroupForm extends StatelessWidget {
  const GroupForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '그룹명을 입력하세요',
              ),
              style: TextStyle(fontSize: 20),
              autofocus: true,
            ),
          ],
        ),
      ),
    );
  }
}
