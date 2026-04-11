import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';

class VisitorModel extends VisitorEntity {
  const VisitorModel({
    required super.id,
    required super.visitorName,
    required super.visitorPhone,
    required super.purpose,
    required super.flatId,
    required super.status,
    super.photoUrl,
    super.residentUid,
    super.societyId,
    super.entryTime,
    super.exitTime,
    super.vehicleNumber,
    super.guardUid,
    super.preApprovalId,
    super.inviteCode,
    super.isGroupEntry,
    super.groupSize,
    super.createdAt,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'] as String,
      visitorName: json['visitorName'] as String,
      visitorPhone: json['visitorPhone'] as String,
      photoUrl: json['photoUrl'] as String?,
      purpose: json['purpose'] as String,
      flatId: json['flatId'] as String,
      residentUid: json['residentUid'] as String?,
      societyId: json['societyId'] as String?,
      entryTime: json['entryTime'] != null
          ? DateTime.parse(json['entryTime'] as String)
          : null,
      exitTime: json['exitTime'] != null
          ? DateTime.parse(json['exitTime'] as String)
          : null,
      status: json['status'] as String,
      vehicleNumber: json['vehicleNumber'] as String?,
      guardUid: json['guardUid'] as String?,
      preApprovalId: json['preApprovalId'] as String?,
      inviteCode: json['inviteCode'] as String?,
      isGroupEntry: json['isGroupEntry'] as bool? ?? false,
      groupSize: json['groupSize'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}

class PreApprovalModel extends PreApprovalEntity {
  const PreApprovalModel({
    required super.id,
    required super.visitorName,
    required super.visitorPhone,
    required super.purpose,
    required super.flatId,
    required super.residentUid,
    required super.inviteCode,
    required super.status,
    super.validFrom,
    super.validUntil,
    super.createdAt,
  });

  factory PreApprovalModel.fromJson(Map<String, dynamic> json) {
    return PreApprovalModel(
      id: json['id'] as String,
      visitorName: json['visitorName'] as String,
      visitorPhone: json['visitorPhone'] as String,
      purpose: json['purpose'] as String,
      flatId: json['flatId'] as String,
      residentUid: json['residentUid'] as String,
      inviteCode: json['inviteCode'] as String,
      status: json['status'] as String,
      validFrom: json['validFrom'] != null
          ? DateTime.parse(json['validFrom'] as String)
          : null,
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
