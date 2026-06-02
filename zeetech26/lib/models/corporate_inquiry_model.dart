class CorporateInquiryModel {
  final int? id;
  final String businessType;
  final String businessName;
  final String repName;
  final String repNumber;
  final String email;
  final String city;
  final String message;
  final DateTime createdAt;
  String status; // 'Pending', 'Approved', 'Completed', 'Cancelled'

  CorporateInquiryModel({
    this.id,
    required this.businessType,
    required this.businessName,
    required this.repName,
    required this.repNumber,
    required this.email,
    required this.city,
    required this.message,
    required this.createdAt,
    this.status = 'Pending',
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'businessType': businessType,
      'businessName': businessName,
      'repName': repName,
      'repNumber': repNumber,
      'email': email,
      'city': city,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory CorporateInquiryModel.fromJson(Map<String, dynamic> json) {
    return CorporateInquiryModel(
      id: json['id'],
      businessType: json['businessType'],
      businessName: json['businessName'],
      repName: json['repName'],
      repNumber: json['repNumber'],
      email: json['email'] ?? '',
      city: json['city'],
      message: json['message'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      status: json['status'] ?? 'Pending',
    );
  }
}
