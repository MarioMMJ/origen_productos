import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/product_repository.dart';
import 'result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ProductRepository _repository = ProductRepository();
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _isProcessing = true);

    final product = await _repository.fetchProduct(code);

    if (mounted) {
      if (product != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(product: product)),
        ).then((_) {
          if (mounted) setState(() => _isProcessing = false);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve product data.')),
        );
        setState(() => _isProcessing = false);
      }
    }
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
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
