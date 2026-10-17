import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';

class RatingView extends StatelessWidget {
  const RatingView({required this.rating, this.style, super.key});

  final double rating;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.bodySmall;
    return Semantics(
      label: 'Rated ${Formatters.rating(rating)} out of 5',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: (textStyle?.fontSize ?? 12) * 1.4,
            color: AppColors.rating,
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(Formatters.rating(rating), style: textStyle),
        ],
      ),
    );
  }
}
