import 'package:equatable/equatable.dart';

class ListingEntity extends Equatable {
  const ListingEntity({required this.id, required this.title, required this.description, required this.category, required this.price, required this.condition, required this.status, this.photos, this.postedBy, this.flatId, this.societyId, this.createdAt});
  final String id; final String title; final String description; final String category; final double price; final String condition; final String status; final List<String>? photos; final String? postedBy; final String? flatId; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, title, status];
}
