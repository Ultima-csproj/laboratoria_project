import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_coffee/core/theme/app_theme.dart';
import 'package:random_coffee/core/theme/theme_provider.dart';
import 'package:random_coffee/features/menu/presentation/screens/menu_screen.dart';

class RandomCoffeeApp  extends ConsumerWidget {
  const RandomCoffeeApp ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Random Coffee',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: const MenuScreen(),
    );
  }
}