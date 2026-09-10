import 'package:flutter_test/flutter_test.dart';
import 'package:product_origin_scanner/domain/product_model.dart';

void main() {
  test('ProductModel origin logic correctly handles Spain', () {
    // 1. Exact string match
    final json = {'product': {'origins': 'Spain'}};
    final model1 = ProductModel.fromJson(json, '123');
    expect(model1.isFromSpain, isTrue);

    // 2. Substring match
    final json2 = {'product': {'manufacturing_places': 'Made in Spain'}};
    final model2 = ProductModel.fromJson(json2, '123');
    expect(model2.isFromSpain, isTrue);

    // 3. Fallback prefix check (no explicit origin, barcode starts with 84)
    final json3 = {'product': {}};
    final model3 = ProductModel.fromJson(json3, '8412345678901');
    expect(model3.isFromSpain, isTrue);

    // 4. Not Spain
    final json4 = {'product': {'countries': 'France'}};
    final model4 = ProductModel.fromJson(json4, '8412345678901'); // Explicit non-Spain origin overrides prefix
    expect(model4.isFromSpain, isFalse);
  });
}
