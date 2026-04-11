import 'package:myguard_frontend/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.status,
    super.societyId,
    super.flatId,
    super.flatNumber,
    super.profilePhotoUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      societyId: json['societyId'] as String?,
      flatId: json['flatId'] as String?,
      flatNumber: json['flatNumber'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'societyId': societyId,
      'flatId': flatId,
      'flatNumber': flatNumber,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }
}

class RegisterRequestModel {
  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.societyId,
    this.flatNumber,
    this.flatId,
    this.profilePhotoUrl,
  });

  final String name;
  final String email;
  final String phone;
  final String role;
  final String? societyId;
  final String? flatNumber;
  final String? flatId;
  final String? profilePhotoUrl;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      if (societyId != null) 'societyId': societyId,
      if (flatNumber != null) 'flatNumber': flatNumber,
      if (flatId != null) 'flatId': flatId,
      if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
    };
  }
}
