class User {
  String id;
  String name;
  String email;
  String password; // only used locally at signup
  bool safe_mode;
  String native_language;
  String current_level;
  int xp_total;
  int streak;
  DateTime? last_activity_date;
  String? donation_status;
  String? last_certificate_link;
  DateTime? last_writing_attempt;

  User({
    this.id = '',
    required this.name,
    required this.email,
    required this.password,
    required this.safe_mode,
    required this.native_language,
    required this.current_level,
    this.xp_total = 0,
    this.streak = 0,
    this.last_activity_date,
    this.donation_status,
    this.last_certificate_link,
    this.last_writing_attempt,
  });

  /// Converts this user object into a format suitable for Supabase DB insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'safe_mode': safe_mode,
      'native_language': native_language,
      'current_level': current_level,
      'xp_total': xp_total,
      'streak': streak,
      'last_activity_date': last_activity_date?.toIso8601String(),
      'donation_status': donation_status,
      'last_certificate_link': last_certificate_link,
      'last_writing_attempt': last_writing_attempt?.toIso8601String(),
    };
  }

  /// Creates a user object from Supabase response
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: '', // We never store/retrieve password from DB
      safe_mode: map['safe_mode'] ?? false,
      native_language: map['native_language'] ?? '',
      current_level: map['current_level'] ?? 'A1',
      xp_total: map['xp_total'] ?? 0,
      streak: map['streak'] ?? 0,
      last_activity_date: map['last_activity_date'] != null
        ? DateTime.tryParse(map['last_activity_date'])
        : null,
      donation_status: map['donation_status'],
      last_certificate_link: map['last_certificate_link'],
      last_writing_attempt: map['last_writing_attempt'] != null
        ? DateTime.tryParse(map['last_writing_attempt'])
        : null,
    );
  }
}