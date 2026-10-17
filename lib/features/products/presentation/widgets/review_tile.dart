import 'package:flutter/material.dart';
import 'package:shopsphere/core/theme/app_colors.dart';
import 'package:shopsphere/core/theme/app_spacing.dart';
import 'package:shopsphere/core/utils/formatters.dart';
import 'package:shopsphere/features/products/domain/entities/review.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({required this.review, super.key});

  final Review review;

  String get _initials {
    final parts = review.reviewerName.trim().split(RegExp(r'\s+'));
    return parts
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: scheme.secondaryContainer,
            child: Text(
              _initials,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.reviewerName, style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xxs),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Semantics(
                      label: 'Rated ${review.rating} out of 5',
                      excludeSemantics: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 1; i <= 5; i++)
                            Icon(
                              i <= review.rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 16,
                              color: i <= review.rating
                                  ? AppColors.rating
                                  : scheme.outline,
                            ),
                        ],
                      ),
                    ),
                    if (review.date != null)
                      Text(
                        Formatters.date(review.date!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(review.comment, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
