class ServicePriceModel {
  final String id;
  final int price;
  final int originalPrice;
  final String? name;
  final String? desc;
  final String? categoryId;
  final bool onSale;
  final int salePercent;

  ServicePriceModel({
    required this.id,
    required this.price,
    required this.originalPrice,
    this.name,
    this.desc,
    this.categoryId,
    this.onSale = false,
    this.salePercent = 0,
  });

  factory ServicePriceModel.fromJson(Map<String, dynamic> json) {
    return ServicePriceModel(
      id: json['id'] as String,
      price: json['price'] as int,
      originalPrice: json['originalPrice'] as int,
      name: json['name'] as String?,
      desc: json['desc'] as String? ?? json['description'] as String?,
      categoryId: json['categoryId'] as String?,
      onSale: json['onSale'] as bool? ?? false,
      salePercent: json['salePercent'] as int? ?? 0,
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
      'onSale': onSale,
      'salePercent': salePercent,
    };
  }
}
