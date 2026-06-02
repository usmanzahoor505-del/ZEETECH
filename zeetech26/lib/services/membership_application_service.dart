import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/membership_application_model.dart';
import 'api_config.dart';

class MembershipApplicationService {
  static Future<String?> submitApplication(MembershipApplicationModel application) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/memberships'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(application.toJson()),
      );
      if (response.statusCode == 200) {
        return null; // Success!
      } else {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is String) {
            return decoded;
          } else if (decoded is Map) {
            if (decoded.containsKey('message')) {
              return decoded['message']?.toString();
            } else if (decoded.containsKey('error')) {
              return decoded['error']?.toString();
            }
          }
        } catch (_) {
          // Not valid JSON
        }
        return response.body.isEmpty ? "An error occurred on the server." : response.body;
      }
    } catch (e) {
      print("Error submitting membership application: $e");
      return "Network error: Unable to connect to backend server.";
    }
  }

  static Future<List<MembershipApplicationModel>> fetchApplications({String? email, String? mobile}) async {
    try {
      String url = '${ApiConfig.backendUrl}/api/memberships';
      final queryParams = <String>[];
      if (email != null && email.isNotEmpty) {
        queryParams.add('email=${Uri.encodeComponent(email)}');
      }
      if (mobile != null && mobile.isNotEmpty) {
        queryParams.add('mobile=${Uri.encodeComponent(mobile)}');
      }
      if (queryParams.isNotEmpty) {
        url += '?${queryParams.join('&')}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => MembershipApplicationModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching membership applications: $e");
      return [];
    }
  }

  static Future<bool> approveApplication(int id, Map<String, String> officialDetails) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.backendUrl}/api/memberships/$id/approve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(officialDetails),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error approving membership application: $e");
      return false;
    }
  }

  static Future<bool> updateStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.backendUrl}/api/memberships/$id/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating status of membership application: $e");
      return false;
    }
  }
}
