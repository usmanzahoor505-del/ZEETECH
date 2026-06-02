import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_price_model.dart';
import 'api_config.dart';

class ProductPriceService {
  static Future<List<ProductPriceModel>> fetchPrices() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.backendUrl}/api/product-prices'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ProductPriceModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> updatePrice({
    required String id,
    required int price,
    required int originalPrice,
    String? name,
    String? desc,
    String? categoryId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/product-prices'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'price': price,
          'originalPrice': originalPrice,
          if (name != null) 'name': name,
          if (desc != null) 'desc': desc,
          if (categoryId != null) 'categoryId': categoryId,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
