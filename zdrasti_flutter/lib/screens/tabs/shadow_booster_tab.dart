import 'package:flutter/material.dart';

class ShadowBoosterTab extends StatelessWidget {
  const ShadowBoosterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F2EE),
      body: Center(
        child: Text(
          'Shadow Booster tab coming soon!',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}