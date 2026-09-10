import 'package:flutter/material.dart';
import '../domain/product_model.dart';

class ResultBottomSheet extends StatelessWidget {
  final ProductModel product;
  final String? restrictedCountry;

  const ResultBottomSheet({super.key, required this.product, this.restrictedCountry});

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
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (restrictedCountry != null)
            Column(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Avoid: Manufactured in $restrictedCountry',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else ...[
            if (product.origin != null)
              Text(
                'Origin: ${product.origin}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            if (product.isFromSpain)
              Column(
                children: [
                  const Icon(Icons.check_circle, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Made in Spain',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Icon(Icons.public, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Not from Spain (or unknown)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
          ],
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
