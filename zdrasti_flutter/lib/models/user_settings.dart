class UserSettings {
  String reminderFrequency;
  String reminderWindow;
  bool kukerNotifications;

  UserSettings({
    required this.reminderFrequency,
    required this.reminderWindow,
    required this.kukerNotifications
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      reminderFrequency: map['reminder_frequency'] ?? 'every_3_days',
      reminderWindow: map['reminder_window'] ?? '08:00–10:00',
      kukerNotifications: map['kuker_notifications'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reminder_frequency': reminderFrequency,
      'reminder_window': reminderWindow,
      'kuker_notifications': kukerNotifications,
    };
  }
}