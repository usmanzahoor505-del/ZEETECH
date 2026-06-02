import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import 'api_config.dart';

class BookingRepository {
  static final BookingRepository _instance = BookingRepository._internal();
  factory BookingRepository() => _instance;

  BookingRepository._internal() {
    fetchBookings();
  }

  final List<BookingModel> _bookings = [];
  final ValueNotifier<List<BookingModel>> bookingsNotifier = ValueNotifier<List<BookingModel>>([]);

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  Future<void> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.backendUrl}/api/bookings'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _bookings.clear();
        for (var item in data) {
          _bookings.add(BookingModel(
            id: item['id'],
            customerName: item['customerName'],
            customerPhone: item['customerPhone'] ?? '',
            customerEmail: item['customerEmail'] ?? '',
            customerAddress: item['customerAddress'] ?? '',
            serviceName: item['serviceName'],
            message: item['message'] ?? '',
            status: item['status'],
            createdAt: DateTime.parse(item['createdAt']),
            preferredDate: item['preferredDate'] ?? '',
            preferredTime: item['preferredTime'] ?? '',
            problemImagePath: item['problemImagePath'] ?? '',
            rating: item['rating'],
            feedbackComment: item['feedbackComment'],
          ));
        }
        // Sort newest first
        _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        bookingsNotifier.value = List.from(_bookings);
      }
    } catch (e) {
      debugPrint("Error fetching bookings: $e");
    }
  }

  Future<bool> addBooking(BookingModel booking) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.backendUrl}/api/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(booking.toJson()),
      );

      if (response.statusCode == 200) {
        _bookings.insert(0, booking);
        bookingsNotifier.value = List.from(_bookings);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error adding booking: $e");
      return false;
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.backendUrl}/api/bookings/$id/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index].status = status;
          bookingsNotifier.value = List.from(_bookings);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating booking status: $e");
      return false;
    }
  }

  Future<bool> submitFeedback(String id, int rating, String feedbackComment) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.backendUrl}/api/bookings/$id/feedback'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rating': rating,
          'feedbackComment': feedbackComment,
        }),
      );

      if (response.statusCode == 200) {
        final index = _bookings.indexWhere((b) => b.id == id);
        if (index != -1) {
          _bookings[index].rating = rating;
          _bookings[index].feedbackComment = feedbackComment;
          bookingsNotifier.value = List.from(_bookings);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error submitting feedback: $e");
      return false;
    }
  }
}
