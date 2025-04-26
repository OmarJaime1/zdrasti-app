import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/models/user.dart';

class DashboardTab extends StatefulWidget {
  final User? user;

  const DashboardTab({super.key, required this.user});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.user != null
        ? widget.user!.name.split(' ').first
        : 'Hero';

    final String greeting = 'Добре дошъл, $name!';
    final String subtext = 'Ready to earn more XP today?';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.deepPurple.shade100,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Greeting text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtext,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Kuker image
                  Image.asset(
                    'assets/images/kuker/kuker_helper.png',
                    height: 80,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Coming Soon Teaser
              const Text(
                'Coming up: Lessons, Streaks, Boss Battles!',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}