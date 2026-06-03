import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class UserAuthService {
  static const String _keyCurrentUser = 'zeetech_current_user';
  static const String _keyCurrentUserDetails = 'zeetech_current_user_details';

  // Send OTP to user's email
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim().toLowerCase()}),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      try {
        final error = jsonDecode(response.body);
        return {
          'success': false, 
          'message': error is Map ? (error['message'] ?? 'Failed to send OTP') : error.toString()
        };
      } catch (_) {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error. Please try again.'};
    }
  }

  // Sign up a new user with OTP
  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName.trim(),
          'email': email.trim().toLowerCase(),
          'phone': phone.trim(),
          'password': password,
          'otp': otp.trim(),
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      }

      try {
        final error = jsonDecode(response.body);
        return {
          'success': false, 
          'message': error is Map ? (error['message'] ?? 'Registration failed') : error.toString()
        };
      } catch (_) {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error. Please try again.'};
    }
  }

  // Login user
  static Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString(_keyCurrentUser, userData['email']);
        await prefs.setString(_keyCurrentUserDetails, response.body);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentUser);
    await prefs.remove(_keyCurrentUserDetails);
  }

  // Get current logged in user email
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentUser);
  }

  // Get current logged in user details
  static Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final detailsJson = prefs.getString(_keyCurrentUserDetails);
    if (detailsJson == null) return null;
    try {
      return jsonDecode(detailsJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Create a new technician account (Admin only action)
  static Future<Map<String, dynamic>> createTechnician({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String specialty,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/technicians/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName.trim(),
          'email': email.trim().toLowerCase(),
          'phone': phone.trim(),
          'password': password,
          'specialty': specialty,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true};
      }
      try {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error is Map ? (error['message'] ?? 'Failed to create technician account') : response.body
        };
      } catch (_) {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error. Please check if the backend server is running and the IP address in api_config.dart is correct.'};
    }
  }

  // Fetch all active approved technicians (Admin / Client assignment list)
  static Future<List<Map<String, dynamic>>> fetchActiveTechnicians() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/technicians/active'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Delete a technician account (Admin only action)
  static Future<bool> deleteTechnician(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.backendUrl}/api/auth/technicians/$id'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
