import 'package:equatable/equatable.dart';

class CheckpointEntity extends Equatable {
  const CheckpointEntity({required this.id, required this.name, required this.location, this.societyId, this.createdAt});
  final String id;
  final String name;
  final String location;
  final String? societyId;
  final DateTime? createdAt;
  @override
  List<Object?> get props => [id, name];
}

class PatrolEntity extends Equatable {
  const PatrolEntity({required this.id, required this.guardUid, required this.checkpointId, this.societyId, this.scannedAt, this.notes, this.createdAt});
  final String id;
  final String guardUid;
  final String checkpointId;
  final String? societyId;
  final DateTime? scannedAt;
  final String? notes;
  final DateTime? createdAt;
  @override
  List<Object?> get props => [id, guardUid, checkpointId];
}

class ShiftEntity extends Equatable {
  const ShiftEntity({required this.id, required this.guardUid, required this.shiftName, required this.startTime, required this.endTime, required this.date, this.societyId, this.status, this.createdAt});
  final String id;
  final String guardUid;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String date;
  final String? societyId;
  final String? status;
  final DateTime? createdAt;
  @override
  List<Object?> get props => [id, guardUid, date];
}
