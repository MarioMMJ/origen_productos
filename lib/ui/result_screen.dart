import 'package:flutter/material.dart';
import '../domain/product_model.dart';

class ResultScreen extends StatelessWidget {
  final ProductModel product;

  const ResultScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                product.name ?? 'Unknown Product',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (product.origin != null)
                Text(
                  'Origin: ${product.origin}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 32),
              if (product.isFromSpain)
                const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 64),
                    SizedBox(height: 8),
                    Text(
                      'Made in Spain',
                      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              else
                const Column(
                  children: [
                    Icon(Icons.public, color: Colors.grey, size: 64),
                    SizedBox(height: 8),
                    Text(
                      'Not from Spain (or unknown)',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
