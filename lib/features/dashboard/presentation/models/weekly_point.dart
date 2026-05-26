class WeeklyPoint {
  final String label;
  final double value;
  final bool isHighlighted;

  const WeeklyPoint({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });
}
