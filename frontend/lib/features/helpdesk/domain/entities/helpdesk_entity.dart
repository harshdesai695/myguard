import 'package:equatable/equatable.dart';

class TicketEntity extends Equatable {
  const TicketEntity({required this.id, required this.title, required this.description, required this.category, required this.status, this.subCategory, this.attachments, this.flatId, this.raisedBy, this.priority, this.assignedTo, this.slaDeadline, this.rating, this.ratingComment, this.societyId, this.createdAt, this.updatedAt});
  final String id; final String title; final String description; final String category; final String status;
  final String? subCategory; final List<String>? attachments; final String? flatId; final String? raisedBy; final String? priority; final String? assignedTo; final DateTime? slaDeadline; final int? rating; final String? ratingComment; final String? societyId; final DateTime? createdAt; final DateTime? updatedAt;
  @override List<Object?> get props => [id, title, status];
}

class CommentEntity extends Equatable {
  const CommentEntity({required this.id, required this.ticketId, required this.authorUid, required this.comment, this.attachments, this.createdAt});
  final String id; final String ticketId; final String authorUid; final String comment; final List<String>? attachments; final DateTime? createdAt;
  @override List<Object?> get props => [id, ticketId];
}
