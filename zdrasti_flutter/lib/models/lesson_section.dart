class LessonSection {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final bool isScored;

  LessonSection({
    required this.id,
    required this.type,
    required this.data,
    this.isScored = false,
  });
}