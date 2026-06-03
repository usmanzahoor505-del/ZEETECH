import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UploadService {
  /// Uploads a local file to the Spring Boot backend and returns the relative /uploads/... URL
  static Future<String?> uploadImage(String localPath) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) return null;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.backendUrl}/api/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'] as String?; // returns e.g. "/uploads/UUID.jpg"
      }
      return null;
    } catch (e) {
      print("File upload exception: $e");
      return null;
    }
  }
}
