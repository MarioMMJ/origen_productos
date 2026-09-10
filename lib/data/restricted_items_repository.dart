import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/product_model.dart';

class RestrictedItemsRepository {
  static const String _key = 'restricted_items';

  Future<List<ProductModel>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString(_key);

    if (itemsJson == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(itemsJson);
      return decodedList
          .map((e) => ProductModel.fromHistoryJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addItem(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    List<ProductModel> items = await getItems();

    // Remove duplicate by barcode if exists
    items.removeWhere((p) => p.barcode == product.barcode);

    // Insert at beginning
    items.insert(0, product);

    // Save to shared_preferences
    final encodedList = jsonEncode(items.map((p) => p.toJson()).toList());
    await prefs.setString(_key, encodedList);
  }
}
