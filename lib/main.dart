import 'package:flutter/material.dart';
import 'ui/scanner_screen.dart';

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
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      theme: ThemeData(
        // Defining theme just in case but we force dark mode
        brightness: Brightness.dark,
      ),
      home: const ScannerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
