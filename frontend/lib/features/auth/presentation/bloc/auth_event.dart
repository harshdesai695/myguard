import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    this.societyId,
    this.flatNumber,
    this.flatId,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? societyId;
  final String? flatNumber;
  final String? flatId;

  @override
  List<Object?> get props => [name, email, phone, password, role, societyId, flatNumber, flatId];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
