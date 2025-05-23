class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final int target;
  final int progress;
  final bool achieved;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.target,
    required this.progress,
    required this.achieved,
    this.unlockedAt,
  });
}

