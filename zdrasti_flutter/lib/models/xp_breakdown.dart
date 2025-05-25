class XpBreakdown {
  final int baseXp;
  final int repeatXp;
  final int streakXp;

  const XpBreakdown({
    this.baseXp = 0,
    this.repeatXp = 0,
    this.streakXp = 0,
  });

  int get total => baseXp + repeatXp + streakXp;

  Map<String, dynamic> toJson() => {
    'baseXp': baseXp,
    'repeatXp': repeatXp,
    'streakXp': streakXp,
    'total': total,
  };
}