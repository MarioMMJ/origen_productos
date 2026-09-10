import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../domain/product_model.dart';

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No Internet Connection']);
  @override
  String toString() => message;
}

class ProductRepository {
  Future<ProductModel?> fetchProduct(String barcode) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw NoInternetException();
      }
    } on SocketException catch (_) {
      throw NoInternetException();
    }

    final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json');
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 0) {
          return null; // Product not found in Open Food Facts
        }
        return ProductModel.fromJson(json, barcode);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Network or timeout error: $e');
    }
  }
}
