import 'package:flutter/material.dart';
import 'package:random_coffee/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: RandomCoffeeApp()));
}
