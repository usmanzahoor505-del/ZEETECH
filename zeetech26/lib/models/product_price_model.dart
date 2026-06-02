class ProductPriceModel {
  final String id;
  final int price;
  final int originalPrice;
  final String? name;
  final String? desc;
  final String? categoryId;

  ProductPriceModel({
    required this.id,
    required this.price,
    required this.originalPrice,
    this.name,
    this.desc,
    this.categoryId,
  });

  factory ProductPriceModel.fromJson(Map<String, dynamic> json) {
    return ProductPriceModel(
      id: json['id'] as String,
      price: json['price'] as int,
      originalPrice: json['originalPrice'] as int,
      name: json['name'] as String?,
      desc: json['desc'] as String? ?? json['description'] as String?,
      categoryId: json['categoryId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'originalPrice': originalPrice,
      'name': name,
      'desc': desc,
      'categoryId': categoryId,
    };
  }
}
