import 'package:myguard_frontend/features/helpdesk/domain/entities/helpdesk_entity.dart';

class TicketModel extends TicketEntity {
  const TicketModel({required super.id, required super.title, required super.description, required super.category, required super.status, super.subCategory, super.attachments, super.flatId, super.raisedBy, super.priority, super.assignedTo, super.slaDeadline, super.rating, super.ratingComment, super.societyId, super.createdAt, super.updatedAt});
  factory TicketModel.fromJson(Map<String, dynamic> j) => TicketModel(id: j['id'] as String, title: j['title'] as String, description: j['description'] as String, category: j['category'] as String, status: j['status'] as String, subCategory: j['subCategory'] as String?, attachments: (j['attachments'] as List<dynamic>?)?.cast<String>(), flatId: j['flatId'] as String?, raisedBy: j['raisedBy'] as String?, priority: j['priority'] as String?, assignedTo: j['assignedTo'] as String?, slaDeadline: j['slaDeadline'] != null ? DateTime.parse(j['slaDeadline'] as String) : null, rating: j['rating'] as int?, ratingComment: j['ratingComment'] as String?, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null, updatedAt: j['updatedAt'] != null ? DateTime.parse(j['updatedAt'] as String) : null);
}

class CommentModel extends CommentEntity {
  const CommentModel({required super.id, required super.ticketId, required super.authorUid, required super.comment, super.attachments, super.createdAt});
  factory CommentModel.fromJson(Map<String, dynamic> j) => CommentModel(id: j['id'] as String, ticketId: j['ticketId'] as String, authorUid: j['authorUid'] as String, comment: j['comment'] as String, attachments: (j['attachments'] as List<dynamic>?)?.cast<String>(), createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}
