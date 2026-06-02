import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_price_model.dart';
import 'api_config.dart';

class ServicePriceService {
  static Future<List<ServicePriceModel>> fetchPrices() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.backendUrl}/api/service-prices'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ServicePriceModel.fromJson(item)).toList();
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
    bool? onSale,
    int? salePercent,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/service-prices'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'price': price,
          'originalPrice': originalPrice,
          if (name != null) 'name': name,
          if (desc != null) 'desc': desc,
          if (categoryId != null) 'categoryId': categoryId,
          if (onSale != null) 'onSale': onSale,
          if (salePercent != null) 'salePercent': salePercent,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
