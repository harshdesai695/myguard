import 'package:equatable/equatable.dart';

class VisitorEntity extends Equatable {
  const VisitorEntity({
    required this.id,
    required this.visitorName,
    required this.visitorPhone,
    required this.purpose,
    required this.flatId,
    required this.status,
    this.photoUrl,
    this.residentUid,
    this.societyId,
    this.entryTime,
    this.exitTime,
    this.vehicleNumber,
    this.guardUid,
    this.preApprovalId,
    this.inviteCode,
    this.isGroupEntry = false,
    this.groupSize,
    this.createdAt,
  });

  final String id;
  final String visitorName;
  final String visitorPhone;
  final String? photoUrl;
  final String purpose;
  final String flatId;
  final String? residentUid;
  final String? societyId;
  final DateTime? entryTime;
  final DateTime? exitTime;
  final String status;
  final String? vehicleNumber;
  final String? guardUid;
  final String? preApprovalId;
  final String? inviteCode;
  final bool isGroupEntry;
  final int? groupSize;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, visitorName, status];
}

class PreApprovalEntity extends Equatable {
  const PreApprovalEntity({
    required this.id,
    required this.visitorName,
    required this.visitorPhone,
    required this.purpose,
    required this.flatId,
    required this.residentUid,
    required this.inviteCode,
    required this.status,
    this.validFrom,
    this.validUntil,
    this.createdAt,
  });

  final String id;
  final String visitorName;
  final String visitorPhone;
  final String purpose;
  final String flatId;
  final String residentUid;
  final String inviteCode;
  final String status;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, inviteCode, status];
}
