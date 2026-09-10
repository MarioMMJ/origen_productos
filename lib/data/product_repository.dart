import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/product_model.dart';

class ProductRepository {
  Future<ProductModel?> fetchProduct(String barcode) async {
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
