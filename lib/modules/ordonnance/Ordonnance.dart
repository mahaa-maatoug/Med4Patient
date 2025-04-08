class Ordonnance {
  final String id; // Now non-nullable since it's always provided
  final String? patientId;
  final String? pharmacyId;
  final List<String> storagePath;
  final PrescriptionStatus prescriptionStatus;
  final bool approved;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? v;

  // Fields that might exist but aren't in this response
  final int? fileSize;
  final DateTime? issueDate;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;
  final DateTime? expiresAt;

  Ordonnance({
    required this.id,
     this.patientId,
     this.pharmacyId,
    required this.storagePath,
    required this.prescriptionStatus,
    this.approved = false,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.v,
    this.fileSize,
    this.issueDate,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
    this.expiresAt,
  });

  factory Ordonnance.fromJson(Map<String, dynamic> json) {
    return Ordonnance(
      id: json['_id'],
      patientId: json['patientId'],
      pharmacyId: json['pharmacyId'],
      storagePath: List<String>.from(json['storagePath']),
      prescriptionStatus: PrescriptionStatus.values.firstWhere(
            (e) => e.toString().split('.').last == json['prescriptionStatus'],
        orElse: () => PrescriptionStatus.UPLOADED,
      ),
      approved: json['approved'] ?? false,
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
      fileSize: json['fileSize'],
      issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate']) : null,
      reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt']) : null,
      reviewedBy: json['reviewedBy'],
      rejectionReason: json['rejectionReason'],
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'pharmacyId': pharmacyId,
      'storagePath': storagePath,
      'prescriptionStatus': prescriptionStatus.toString().split('.').last,
      'approved': approved,
      if (note != null) 'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (v != null) '__v': v,
      if (fileSize != null) 'fileSize': fileSize,
      if (issueDate != null) 'issueDate': issueDate?.toIso8601String(),
      if (reviewedAt != null) 'reviewedAt': reviewedAt?.toIso8601String(),
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (expiresAt != null) 'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

enum PrescriptionStatus {
  UPLOADED,
  IN_REVIEW,
  NEEDS_CLARIFICATION,
  APPROVED,
  REJECTED,
  EXPIRED,
  ARCHIVED,
}