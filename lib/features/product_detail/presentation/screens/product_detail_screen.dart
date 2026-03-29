import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/core/theme/app_colors.dart';
import 'package:random_coffee/core/theme/theme_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String name;
  final int price;
  final String? description;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConstants.verticalPadding),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.pop(context),
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: cs.onSurface,
                      size: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 218,
                            width: 218,
                            color: cs.onPrimary, //надо будет поменять
                            child: Image.asset(
                              'assets/images/coffee.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(
                          height: AppConstants.verticalPadding,
                        ),
                        if (description != null)
                          Text(
                            description!,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: cs.onSurface.withValues(alpha: 0.9),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: AppConstants.horizontalPadding,
              bottom: AppConstants.verticalPadding,
              child: GestureDetector(
                onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    isDark ? Icons.nightlight : Icons.wb_sunny_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
