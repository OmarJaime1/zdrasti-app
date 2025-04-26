import 'package:flutter/material.dart';

class KukerCustomizationScreen extends StatelessWidget {
  const KukerCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(title: const Text('Customize Your Kuker')),
      body: const Center(
        child: Text(
          'Kuker Customization Coming Soon!',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ),
    );
  }
}