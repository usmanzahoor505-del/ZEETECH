class MembershipApplicationModel {
  final int? id;
  final String category; // 'Domestic' or 'Commercial'
  final String planName; // 'Silver', 'Gold', 'Premium'
  final String discount; // '10%', '20%', '30%'
  final String validity; // '3 Months', '6 Months', '1 Year'
  final DateTime createdAt;
  String status; // 'Pending', 'Approved', 'Rejected'

  // Applicant Information
  final String fullName;
  final String fatherName;
  final String cnic;
  final String dob;
  final String occupation;

  // Contact Information
  final String mobile;
  final String altContact;
  final String email;
  final String address;
  final String preferredServices;

  // For Official Use Only
  final String? membershipId;
  final String? initiatedBy;
  final String? remarks;
  final String? officerName;
  final String? officerDesignation;
  final String? officerEmpId;
  final DateTime? processedAt;

  MembershipApplicationModel({
    this.id,
    required this.category,
    required this.planName,
    required this.discount,
    required this.validity,
    required this.createdAt,
    this.status = 'Pending',
    required this.fullName,
    required this.fatherName,
    required this.cnic,
    required this.dob,
    this.occupation = '',
    required this.mobile,
    this.altContact = '',
    this.email = '',
    required this.address,
    this.preferredServices = '',
    this.membershipId,
    this.initiatedBy,
    this.remarks,
    this.officerName,
    this.officerDesignation,
    this.officerEmpId,
    this.processedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'category': category,
      'planName': planName,
      'discount': discount,
      'validity': validity,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'fullName': fullName,
      'fatherName': fatherName,
      'cnic': cnic,
      'dob': dob,
      'occupation': occupation,
      'mobile': mobile,
      'altContact': altContact,
      'email': email,
      'address': address,
      'preferredServices': preferredServices,
      if (membershipId != null) 'membershipId': membershipId,
      if (initiatedBy != null) 'initiatedBy': initiatedBy,
      if (remarks != null) 'remarks': remarks,
      if (officerName != null) 'officerName': officerName,
      if (officerDesignation != null) 'officerDesignation': officerDesignation,
      if (officerEmpId != null) 'officerEmpId': officerEmpId,
      if (processedAt != null) 'processedAt': processedAt!.toIso8601String(),
    };
  }

  factory MembershipApplicationModel.fromJson(Map<String, dynamic> json) {
    return MembershipApplicationModel(
      id: json['id'],
      category: json['category'] ?? '',
      planName: json['planName'] ?? '',
      discount: json['discount'] ?? '',
      validity: json['validity'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      status: json['status'] ?? 'Pending',
      fullName: json['fullName'] ?? '',
      fatherName: json['fatherName'] ?? '',
      cnic: json['cnic'] ?? '',
      dob: json['dob'] ?? '',
      occupation: json['occupation'] ?? '',
      mobile: json['mobile'] ?? '',
      altContact: json['altContact'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      preferredServices: json['preferredServices'] ?? '',
      membershipId: json['membershipId'],
      initiatedBy: json['initiatedBy'],
      remarks: json['remarks'],
      officerName: json['officerName'],
      officerDesignation: json['officerDesignation'],
      officerEmpId: json['officerEmpId'],
      processedAt: json['processedAt'] != null ? DateTime.parse(json['processedAt']) : null,
    );
  }
}
