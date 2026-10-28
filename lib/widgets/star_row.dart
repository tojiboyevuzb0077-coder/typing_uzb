import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StarRow extends StatelessWidget {
  final int stars; // 0 to 3
  final double size;

  const StarRow({super.key, required this.stars, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isFilled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            isFilled ? Icons.star : Icons.star_border,
            color: isFilled ? AppColors.star : Colors.grey,
            size: size,
          ),
        );
      }),
    );
  }
}
