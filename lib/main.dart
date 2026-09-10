import 'package:flutter/material.dart';
import 'ui/main_navigation.dart';
import 'theme.dart';

void main() {
  runApp(const ProductOriginScannerApp());
}

class ProductOriginScannerApp extends StatelessWidget {
  const ProductOriginScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Origin Scanner',
      themeMode: ThemeMode.dark, // Strictly dark mode as per requirements
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.darkTheme, // Defining theme just in case but we force dark mode
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
