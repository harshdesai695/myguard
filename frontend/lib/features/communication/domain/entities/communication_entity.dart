import 'package:equatable/equatable.dart';

class NoticeEntity extends Equatable {
  const NoticeEntity({required this.id, required this.title, required this.body, required this.type, this.attachments, this.postedBy, this.postedAt, this.expiryDate, this.societyId, this.createdAt});
  final String id; final String title; final String body; final String type;
  final List<String>? attachments; final String? postedBy; final DateTime? postedAt; final DateTime? expiryDate; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, title, type];
}

class PollEntity extends Equatable {
  const PollEntity({required this.id, required this.question, required this.options, this.startDate, this.endDate, this.isSecret = false, this.allowMultipleVotes = false, this.createdBy, this.societyId, this.results, this.totalVotes, this.createdAt});
  final String id; final String question; final List<String> options;
  final DateTime? startDate; final DateTime? endDate; final bool isSecret; final bool allowMultipleVotes;
  final String? createdBy; final String? societyId; final Map<String, dynamic>? results; final int? totalVotes; final DateTime? createdAt;
  @override List<Object?> get props => [id, question];
}

class GroupEntity extends Equatable {
  const GroupEntity({required this.id, required this.name, this.memberUids, this.societyId, this.createdAt});
  final String id; final String name; final List<String>? memberUids; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, name];
}

class MessageEntity extends Equatable {
  const MessageEntity({required this.id, required this.groupId, required this.senderId, required this.content, this.mediaUrl, this.createdAt});
  final String id; final String groupId; final String senderId; final String content; final String? mediaUrl; final DateTime? createdAt;
  @override List<Object?> get props => [id, groupId];
}

class DocumentEntity extends Equatable {
  const DocumentEntity({required this.id, required this.title, required this.fileUrl, required this.type, this.societyId, this.createdAt});
  final String id; final String title; final String fileUrl; final String type; final String? societyId; final DateTime? createdAt;
  @override List<Object?> get props => [id, title];
}
