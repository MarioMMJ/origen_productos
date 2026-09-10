import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/product_model.dart';

class ProductRepository {
  Future<ProductModel?> fetchProduct(String barcode) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ProductModel.fromJson(json, barcode);
      }
    } catch (e) {
      // Graceful error handling by returning null on network failures.
    }
    return null;
  }
}
