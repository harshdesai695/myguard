import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';

class DailyHelpModel extends DailyHelpEntity {
  const DailyHelpModel({
    required super.id, required super.name, required super.phone,
    required super.type, super.photoUrl, super.residentUid,
    super.flatIds, super.societyId, super.schedule, super.createdAt,
  });

  factory DailyHelpModel.fromJson(Map<String, dynamic> json) => DailyHelpModel(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    type: json['type'] as String,
    photoUrl: json['photoUrl'] as String?,
    residentUid: json['residentUid'] as String?,
    flatIds: (json['flatIds'] as List<dynamic>?)?.cast<String>(),
    societyId: json['societyId'] as String?,
    schedule: json['schedule'] as Map<String, dynamic>?,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );
}

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id, required super.dailyHelpId,
    required super.date, required super.status, super.markedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    id: json['id'] as String,
    dailyHelpId: json['dailyHelpId'] as String,
    date: json['date'] as String,
    status: json['status'] as String,
    markedAt: json['markedAt'] != null ? DateTime.parse(json['markedAt'] as String) : null,
  );
}
