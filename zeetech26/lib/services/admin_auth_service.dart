import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAuthService {
  static const String _keyAdmins = 'zeetech_admins';
  static const String _keyCurrentAdmin = 'zeetech_current_admin';

  // Default fallback credentials
  static final Map<String, String> _defaultAdmins = {
    'admin': 'admin123',
    'developer': 'zeetech2026',
  };

  // Sign up a new admin (requires security registration code)
  static Future<bool> registerAdmin(String username, String password, String adminCode) async {
    if (adminCode.trim().toUpperCase() != 'ZEETECH-ADMIN-2026') {
      return false; // Invalid developer signup code
    }
    
    final prefs = await SharedPreferences.getInstance();
    final adminsJson = prefs.getString(_keyAdmins) ?? '{}';
    final Map<String, dynamic> admins = jsonDecode(adminsJson);
    
    final normalizedUsername = username.trim().toLowerCase();
    if (admins.containsKey(normalizedUsername) || _defaultAdmins.containsKey(normalizedUsername)) {
      return false; // Username already exists
    }
    
    admins[normalizedUsername] = password;
    await prefs.setString(_keyAdmins, jsonEncode(admins));
    return true;
  }

  // Login admin
  static Future<bool> loginAdmin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final adminsJson = prefs.getString(_keyAdmins) ?? '{}';
    final Map<String, dynamic> admins = jsonDecode(adminsJson);
    
    final normalizedUsername = username.trim().toLowerCase();
    if (admins[normalizedUsername] == password || _defaultAdmins[normalizedUsername] == password) {
      await prefs.setBool(_keyCurrentAdmin, true);
      return true;
    }
    return false;
  }

  // Logout admin
  static Future<void> logoutAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCurrentAdmin);
  }

  // Check if admin is logged in
  static Future<bool> isAdminLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCurrentAdmin) ?? false;
  }
}
