import 'package:flutter/material.dart';
import '../domain/product_model.dart';

class ResultBottomSheet extends StatelessWidget {
  final ProductModel product;

  const ResultBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            product.name ?? 'Unknown Product',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            product.brand ?? 'Unknown Brand',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (product.origin != null)
            Text(
              'Origin: ${product.origin}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),
          if (product.isFromSpain)
            const Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 8),
                Text(
                  'Made in Spain',
                  style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
          else
            const Column(
              children: [
                Icon(Icons.public, color: Colors.grey, size: 48),
                SizedBox(height: 8),
                Text(
                  'Not from Spain (or unknown)',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Scan Another Product'),
          ),
        ],
      ),
    );
  }
}
