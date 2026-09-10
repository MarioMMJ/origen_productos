import 'package:flutter/material.dart';
import '../domain/product_model.dart';
import '../theme.dart';

class ResultBottomSheet extends StatelessWidget {
  final ProductModel product;
  final String? restrictedCountry;

  const ResultBottomSheet({super.key, required this.product, this.restrictedCountry});

  @override
  Widget build(BuildContext context) {
    final bool isRestricted = restrictedCountry != null;
    final bool isLocal = product.isFromSpain;

    final Color statusColor = isRestricted
        ? AppTheme.statusRed
        : (isLocal ? AppTheme.statusGreen : AppTheme.statusGrey);

    final String statusText = isRestricted
        ? 'Avoid: $restrictedCountry'
        : (isLocal ? 'Made in Spain' : 'Other Origin');

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.scaffoldBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.hardEdge,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 32, color: AppTheme.statusGrey),
                      )
                    : const Icon(Icons.image_not_supported, size: 32, color: AppTheme.statusGrey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unknown Product',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand ?? 'Unknown Brand',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25), // ~0.1 opacity
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: statusColor.withAlpha(127), width: 2), // ~0.5 opacity
            ),
            child: Row(
              children: [
                Icon(
                  isRestricted
                      ? Icons.warning_amber_rounded
                      : (isLocal ? Icons.check_circle : Icons.public),
                  color: statusColor,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: statusColor),
                      ),
                      if (product.origin != null && !isRestricted && !isLocal)
                        Text(
                          'Origin: ${product.origin}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.scaffoldBackground,
            ),
            child: const Text('Scan Another Product'),
          ),
        ],
      ),
    );
  }
}
