import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: AppConstants.componentSpacing),
        itemBuilder: (context, index) {
          final sel = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? cs.primary : cs.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? Colors.white : cs.onSurface,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}