import 'package:flutter/material.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F2EE),
      body: Center(
        child: Text(
          'Practice Chat tab coming soon!',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}