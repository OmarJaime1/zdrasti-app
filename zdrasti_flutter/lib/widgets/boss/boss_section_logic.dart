mixin BossSectionLogic {
  /// Whether the user has submitted their answers
  bool get hasSubmitted;

  /// Returns a score between 0.0 and 1.0 for how well the user performed
  double getScore();
}
