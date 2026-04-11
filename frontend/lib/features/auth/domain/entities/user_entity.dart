import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.societyId,
    this.flatId,
    this.flatNumber,
    this.profilePhotoUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String? societyId;
  final String? flatId;
  final String? flatNumber;
  final String? profilePhotoUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isResident => role == 'ROLE_RESIDENT';
  bool get isGuard => role == 'ROLE_GUARD';
  bool get isAdmin => role == 'ROLE_ADMIN';
  bool get isActive => status == 'ACTIVE';

  @override
  List<Object?> get props => [
        uid, name, email, phone, role, status,
        societyId, flatId, flatNumber, profilePhotoUrl,
      ];
}
