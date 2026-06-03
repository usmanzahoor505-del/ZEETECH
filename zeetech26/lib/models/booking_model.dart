class BookingModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String customerAddress;
  final String serviceName;
  final String message;
  String status; // 'Pending', 'In Progress', 'Completed', 'Cancelled'
  final DateTime createdAt;
  final String preferredDate;
  final String preferredTime;
  final String problemImagePath;
  int? rating;
  String? feedbackComment;
  String? assignedWorker;
  String? startedAt;
  String? completedAt;
  String? workSummary;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.serviceName,
    required this.message,
    this.status = 'Pending',
    required this.createdAt,
    this.preferredDate = '',
    this.preferredTime = '',
    this.problemImagePath = '',
    this.rating,
    this.feedbackComment,
    this.assignedWorker,
    this.startedAt,
    this.completedAt,
    this.workSummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'serviceName': serviceName,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'problemImagePath': problemImagePath,
      'rating': rating,
      'feedbackComment': feedbackComment,
      'assignedWorker': assignedWorker,
      'startedAt': startedAt,
      'completedAt': completedAt,
      'workSummary': workSummary,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerAddress: json['customerAddress'],
      serviceName: json['serviceName'],
      message: json['message'],
      status: json['status'] ?? 'Pending',
      createdAt: DateTime.parse(json['createdAt']),
      preferredDate: json['preferredDate'] ?? '',
      preferredTime: json['preferredTime'] ?? '',
      problemImagePath: json['problemImagePath'] ?? '',
      rating: json['rating'],
      feedbackComment: json['feedbackComment'],
      assignedWorker: json['assignedWorker'],
      startedAt: json['startedAt'],
      completedAt: json['completedAt'],
      workSummary: json['workSummary'],
    );
  }
}
