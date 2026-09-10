import 'package:flutter/material.dart';
import '../data/restricted_items_repository.dart';
import '../domain/product_model.dart';
import 'result_bottom_sheet.dart';
import '../theme.dart';

class RestrictedItemsScreen extends StatefulWidget {
  const RestrictedItemsScreen({super.key});

  @override
  State<RestrictedItemsScreen> createState() => _RestrictedItemsScreenState();
}

class _RestrictedItemsScreenState extends State<RestrictedItemsScreen> {
  final RestrictedItemsRepository _repository = RestrictedItemsRepository();
  List<ProductModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await _repository.getItems();
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  void _showResultBottomSheet(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResultBottomSheet(product: product, restrictedCountry: product.origin), // Using origin here as restricted country for UI simplicity
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restricted Items'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'No restricted items flagged yet.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = _items[index];
                    return InkWell(
                      onTap: () => _showResultBottomSheet(product),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppTheme.statusRed.withAlpha(127), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.scaffoldBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: product.imageUrl != null
                                  ? Image.network(
                                      product.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: AppTheme.statusGrey),
                                    )
                                  : const Icon(Icons.image_not_supported, color: AppTheme.statusGrey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name ?? 'Unknown Product',
                                    style: Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Origin: ${product.origin ?? 'Unknown'}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.statusRed),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: AppTheme.statusRed,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
