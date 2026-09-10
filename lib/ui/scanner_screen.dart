import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/product_repository.dart';
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
  ScannerState _state = ScannerState.scanning;
  String? _lastScannedCode;
  DateTime? _lastScannedTime;

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

    setState(() => _state = ScannerState.loading);

    try {
      final product = await _repository.fetchProduct(code);

      if (!mounted) return;

      if (product != null) {
        setState(() => _state = ScannerState.success);
        _showResultBottomSheet(product);
      } else {
        setState(() => _state = ScannerState.notFound);
        _showErrorBottomSheet('Product not found in database.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _state = ScannerState.error);
      _showErrorBottomSheet('Error fetching product data.');
    }
  }

  void _showResultBottomSheet(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResultBottomSheet(product: product),
    ).whenComplete(() {
      if (mounted) setState(() => _state = ScannerState.scanning);
    });
  }

  void _showErrorBottomSheet(String message) {
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
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product Barcode')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
            controller: MobileScannerController(
              formats: const [BarcodeFormat.ean13],
            ),
          ),
          if (_state == ScannerState.loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
