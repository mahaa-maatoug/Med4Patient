enum StockStatus {
  IN_STOCK,
  OUT_OF_STOCK,
}

class Category {
  final String idcategory;
  final String type;

  Category({required this.idcategory, required this.type});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idcategory: json['_id'] ?? json['idcategory'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final List<String> storagePath;
  final Category category;
  final bool showPrice;  // Changed back to boolean
  final StockStatus stockStatus;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.storagePath,
    required this.category,
    required this.showPrice,
    required this.stockStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      showPrice: json['showPrice'] ?? true,  // Direct boolean assignment
      stockStatus: _parseStockStatus(json['stockStatus']),
      storagePath: List<String>.from(json['storagePath']?.map((path) =>
          path.replaceAll(r'\', '/')
      ) ?? []),
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(idcategory: '', type: 'Uncategorized'),
    );
  }

  static StockStatus _parseStockStatus(dynamic value) {
    if (value == null) return StockStatus.OUT_OF_STOCK;
    if (value is String) {
      return StockStatus.values.firstWhere(
            (e) => e.toString().split('.').last == value,
        orElse: () => StockStatus.OUT_OF_STOCK,
      );
    }
    return value ? StockStatus.IN_STOCK : StockStatus.OUT_OF_STOCK;
  }

  bool get canBePurchased => stockStatus == StockStatus.IN_STOCK;
}
