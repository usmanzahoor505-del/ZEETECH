import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/corporate_inquiry_model.dart';
import 'api_config.dart';

class CorporateInquiryService {
  static Future<List<CorporateInquiryModel>> fetchInquiries({String? email, String? repNumber}) async {
    try {
      String url = '${ApiConfig.backendUrl}/api/corporate-inquiries';
      final queryParams = <String>[];
      if (email != null && email.isNotEmpty) {
        queryParams.add('email=${Uri.encodeComponent(email)}');
      }
      if (repNumber != null && repNumber.isNotEmpty) {
        queryParams.add('repNumber=${Uri.encodeComponent(repNumber)}');
      }
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => CorporateInquiryModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching inquiries: $e");
      return [];
    }
  }

  static Future<bool> submitInquiry(CorporateInquiryModel inquiry) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/corporate-inquiries'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inquiry.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error submitting inquiry: $e");
      return false;
    }
  }

  static Future<bool> updateStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.backendUrl}/api/corporate-inquiries/$id/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }
}
