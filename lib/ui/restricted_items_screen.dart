import 'package:flutter/material.dart';
import '../data/restricted_items_repository.dart';
import '../domain/product_model.dart';
import 'result_bottom_sheet.dart';

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
      builder: (context) => ResultBottomSheet(product: product),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final product = _items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        onTap: () => _showResultBottomSheet(product),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name ?? 'Unknown Product',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Brand: ${product.brand ?? 'Unknown Brand'}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Origin: ${product.origin ?? 'Unknown Origin'}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: null, // Disabled placeholder for future alternatives
                                  child: const Text('Suggested Alternatives'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
