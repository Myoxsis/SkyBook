import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final double size;

  const StarRating({super.key, required this.rating, required this.onRatingChanged, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: size,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: color,
          ),
          onPressed: () => onRatingChanged(index + 1),
        );
      }),
    );
  }
}
