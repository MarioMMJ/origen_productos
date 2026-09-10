import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/product_model.dart';

class HistoryRepository {
  static const String _historyKey = 'scan_history';
  static const int _maxHistoryLength = 20;

  Future<List<ProductModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_historyKey);

    if (historyJson == null) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(historyJson);
      return decodedList.map((e) => ProductModel.fromHistoryJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    List<ProductModel> history = await getHistory();

    // Remove duplicate by barcode if exists
    history.removeWhere((p) => p.barcode == product.barcode);

    // Insert at beginning
    history.insert(0, product);

    // Trim to max length
    if (history.length > _maxHistoryLength) {
      history = history.sublist(0, _maxHistoryLength);
    }

    // Save to shared_preferences
    final encodedList = jsonEncode(history.map((p) => p.toJson()).toList());
    await prefs.setString(_historyKey, encodedList);
  }
}
