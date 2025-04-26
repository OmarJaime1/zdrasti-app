import 'package:flutter/material.dart';
import 'package:zdrasti_flutter/backend/service/user_settings_service.dart';
import 'package:zdrasti_flutter/models/user.dart';
import 'package:zdrasti_flutter/models/user_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({super.key, required this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettings? _settings;
  bool _isLoading = true;
  bool _isOffline = false;
  bool _isSaving = false;

  final List<String> frequencies = ['never', 'weekly', 'every_3_days', 'daily'];
  final List<String> timeWindows = ['08:00–10:00', '12:00–14:00', '18:00–20:00'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await UserSettingsService.fetchSettings(widget.user.id);
      setState(() {
        _settings = settings ?? UserSettings(
          reminderFrequency: 'every_3_days',
          reminderWindow: '08:00–10:00',
          kukerNotifications: true,
        );
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Failed to load settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    if (_settings == null) return;
    setState(() => _isSaving = true);
    try {
      await UserSettingsService.saveSettings(widget.user.id, _settings!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Settings saved!')),
      );
    } catch (e) {
      debugPrint('❌ Failed to save settings: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Image.asset('assets/images/kuker/kuker_helper.png', height: 100),

            const SizedBox(height: 24),
            const Text('🔔 Reminder Settings', style: TextStyle(fontWeight: FontWeight.bold)),

            SwitchListTile(
              title: const Text('Enable Kuker Reminders'),
              value: _settings!.kukerNotifications,
              onChanged: (val) {
                setState(() => _settings!.kukerNotifications = val);
                _saveSettings();
              },
            ),

            DropdownButtonFormField<String>(
              value: _settings!.reminderFrequency,
              decoration: const InputDecoration(labelText: 'Reminder Frequency'),
              items: frequencies.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _settings!.reminderFrequency = val);
                  _saveSettings();
                }
              },
            ),

            DropdownButtonFormField<String>(
              value: _settings!.reminderWindow,
              decoration: const InputDecoration(labelText: 'Reminder Time Window'),
              items: timeWindows.map((tw) => DropdownMenuItem(value: tw, child: Text(tw))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _settings!.reminderWindow = val);
                  _saveSettings();
                }
              },
            ),

            const SizedBox(height: 32),
            const Text('🛡️ Safe Mode', style: TextStyle(fontWeight: FontWeight.bold)),

            SwitchListTile(
              title: const Text('Enable Safe Mode'),
              value: widget.user.safe_mode,
              onChanged: null, // 🔒 locked from onboarding
              subtitle: const Text(
                'Safe Mode is required for younger learners.\nContent is filtered automatically.',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 32),
            if (_isOffline)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: const [
                    Text('⚠️ You’re in offline mode.', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Some features may be limited until connection is restored.'),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            if (_isSaving)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}