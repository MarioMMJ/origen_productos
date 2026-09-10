class ProductModel {
  final String barcode;
  final String? name;
  final String? brand;
  final String? origin;
  final bool isFromSpain;
  final DateTime? timestamp;

  ProductModel({
    required this.barcode,
    this.name,
    this.brand,
    this.origin,
    required this.isFromSpain,
    this.timestamp,
  });

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
      barcode: barcode,
      name: product['product_name']?.toString() ?? 'Unknown Product',
      brand: product['brands']?.toString().isNotEmpty == true ? product['brands'] : 'Unknown Brand',
      origin: finalOrigin,
      isFromSpain: fromSpain,
      timestamp: DateTime.now(),
    );
  }

  factory ProductModel.fromHistoryJson(Map<String, dynamic> json) {
    return ProductModel(
      barcode: json['barcode'] as String,
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      origin: json['origin'] as String?,
      isFromSpain: json['isFromSpain'] as bool? ?? false,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'name': name,
        'brand': brand,
        'origin': origin,
        'isFromSpain': isFromSpain,
        'timestamp': timestamp?.toIso8601String(),
      };
}
