class Achievement {
  final String id;
  final String title;
  final String description;
  final int target;
  final int progress;
  final bool achieved;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.progress,
    required this.achieved,
  });
}

