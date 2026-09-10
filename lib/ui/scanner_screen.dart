import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/product_repository.dart';
import '../data/history_repository.dart';
import '../data/restricted_countries_repository.dart';
import '../data/restricted_items_repository.dart';
import '../domain/product_model.dart';
import 'result_bottom_sheet.dart';

enum ScannerState { scanning, loading, success, error, notFound }

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ProductRepository _repository = ProductRepository();
  final HistoryRepository _historyRepository = HistoryRepository();
  final RestrictedCountriesRepository _restrictedCountriesRepo = RestrictedCountriesRepository();
  final RestrictedItemsRepository _restrictedItemsRepo = RestrictedItemsRepository();
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.ean13],
  );
  ScannerState _state = ScannerState.scanning;
  String? _lastScannedCode;
  DateTime? _lastScannedTime;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_state != ScannerState.scanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    final now = DateTime.now();
    if (_lastScannedCode == code && _lastScannedTime != null) {
      if (now.difference(_lastScannedTime!) < const Duration(seconds: 3)) {
        return; // Debounce
      }
    }

    _lastScannedCode = code;
    _lastScannedTime = now;

    await _processBarcode(code);
  }

  Future<void> _processBarcode(String code) async {
    HapticFeedback.vibrate().catchError((_) {});

    setState(() => _state = ScannerState.loading);

    try {
      final product = await _repository.fetchProduct(code);

      if (!mounted) return;

      if (product != null) {
        await _historyRepository.addProduct(product);

        String? matchedRestrictedCountry;
        final restrictedCountries = await _restrictedCountriesRepo.getCountries();

        if (product.origin != null) {
          final originLower = product.origin!.toLowerCase();
          for (final country in restrictedCountries) {
            if (originLower.contains(country.toLowerCase())) {
              matchedRestrictedCountry = country;
              await _restrictedItemsRepo.addItem(product);
              break;
            }
          }
        }

        if (!mounted) return;
        setState(() => _state = ScannerState.success);
        _showResultBottomSheet(product, matchedRestrictedCountry);
      } else {
        setState(() => _state = ScannerState.notFound);
        if (code.startsWith('84')) {
          _showErrorBottomSheet('Origin unknown, but registered by a Spanish distributor.', isInfo: true);
        } else {
          _showErrorBottomSheet('Product not found in database.');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _state = ScannerState.error);
      if (e is NoInternetException) {
        _showErrorBottomSheet('No Internet Connection');
      } else {
        _showErrorBottomSheet('Error fetching product data.');
      }
    }
  }

  void _showResultBottomSheet(ProductModel product, String? restrictedCountry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResultBottomSheet(product: product, restrictedCountry: restrictedCountry),
    ).whenComplete(() {
      if (mounted) setState(() => _state = ScannerState.scanning);
    });
  }

  void _showErrorBottomSheet(String message, {bool isInfo = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isInfo ? Icons.info_outline : Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _state = ScannerState.scanning);
    });
  }

  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Barcode Manually'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'e.g. 8412345678901',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = controller.text.trim();
              if (code.length == 8 || code.length == 13) {
                Navigator.of(context).pop();
                _processBarcode(code);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barcode must be 8 or 13 digits.')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            controller: _controller,
          ),
          // Minimalist scanning reticle
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 2),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          if (_state == ScannerState.loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'manual_entry',
                  onPressed: _showManualEntryDialog,
                  child: const Icon(Icons.edit),
                ),
                ValueListenableBuilder(
                  valueListenable: _controller,
                  builder: (context, state, child) {
                    switch (state.torchState) {
                      case TorchState.off:
                      case TorchState.auto:
                        return FloatingActionButton(
                          heroTag: 'torch',
                          onPressed: () => _controller.toggleTorch(),
                          child: const Icon(Icons.flash_off),
                        );
                      case TorchState.on:
                        return FloatingActionButton(
                          heroTag: 'torch',
                          onPressed: () => _controller.toggleTorch(),
                          child: const Icon(Icons.flash_on),
                        );
                      case TorchState.unavailable:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
