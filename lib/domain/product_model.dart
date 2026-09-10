class ProductModel {
  final String? name;
  final String? origin;
  final bool isFromSpain;

  ProductModel({this.name, this.origin, required this.isFromSpain});

  factory ProductModel.fromJson(Map<String, dynamic> json, String barcode) {
    final product = json['product'] ?? {};

    final String? origins = product['origins']?.toString().isNotEmpty == true ? product['origins'] : null;
    final String? manufacturingPlaces = product['manufacturing_places']?.toString().isNotEmpty == true ? product['manufacturing_places'] : null;
    final String? countries = product['countries']?.toString().isNotEmpty == true ? product['countries'] : null;

    final String? finalOrigin = origins ?? manufacturingPlaces ?? countries;

    bool fromSpain = false;
    if (finalOrigin != null && finalOrigin.toLowerCase().contains('spain')) {
      fromSpain = true;
    } else if (finalOrigin == null && barcode.startsWith('84')) {
      fromSpain = true;
    }

    return ProductModel(
      name: product['product_name']?.toString() ?? 'Unknown Product',
      origin: finalOrigin,
      isFromSpain: fromSpain,
    );
  }
}
