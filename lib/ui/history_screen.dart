import 'package:flutter/material.dart';
import '../data/history_repository.dart';
import '../domain/product_model.dart';
import 'result_bottom_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryRepository _repository = HistoryRepository();
  List<ProductModel> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _repository.getHistory();
    if (mounted) {
      setState(() {
        _history = history;
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
        title: const Text('Scan History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? Center(
                  child: Text(
                    'No scan history yet.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final product = _history[index];
                    return ListTile(
                      title: Text(product.name ?? 'Unknown Product'),
                      subtitle: Text(
                        '${product.brand ?? 'Unknown Brand'}\n${product.timestamp?.toString().split('.').first ?? ''}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: product.isFromSpain
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.public, color: Colors.grey),
                      isThreeLine: true,
                      onTap: () => _showResultBottomSheet(product),
                    );
                  },
                ),
    );
  }
}
