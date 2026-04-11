import 'package:equatable/equatable.dart';

class DailyHelpEntity extends Equatable {
  const DailyHelpEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.type,
    this.photoUrl,
    this.residentUid,
    this.flatIds,
    this.societyId,
    this.schedule,
    this.createdAt,
  });

  final String id;
  final String name;
  final String phone;
  final String? photoUrl;
  final String type;
  final String? residentUid;
  final List<String>? flatIds;
  final String? societyId;
  final Map<String, dynamic>? schedule;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, name, type];
}

class AttendanceEntity extends Equatable {
  const AttendanceEntity({
    required this.id,
    required this.dailyHelpId,
    required this.date,
    required this.status,
    this.markedAt,
  });

  final String id;
  final String dailyHelpId;
  final String date;
  final String status;
  final DateTime? markedAt;

  @override
  List<Object?> get props => [id, dailyHelpId, date];
}
