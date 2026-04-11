import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';

class NoticeModel extends NoticeEntity {
  const NoticeModel({required super.id, required super.title, required super.body, required super.type, super.attachments, super.postedBy, super.postedAt, super.expiryDate, super.societyId, super.createdAt});
  factory NoticeModel.fromJson(Map<String, dynamic> j) => NoticeModel(id: j['id'] as String, title: j['title'] as String, body: j['body'] as String, type: j['type'] as String, attachments: (j['attachments'] as List<dynamic>?)?.cast<String>(), postedBy: j['postedBy'] as String?, postedAt: j['postedAt'] != null ? DateTime.parse(j['postedAt'] as String) : null, expiryDate: j['expiryDate'] != null ? DateTime.parse(j['expiryDate'] as String) : null, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class PollModel extends PollEntity {
  const PollModel({required super.id, required super.question, required super.options, super.startDate, super.endDate, super.isSecret, super.allowMultipleVotes, super.createdBy, super.societyId, super.results, super.totalVotes, super.createdAt});
  factory PollModel.fromJson(Map<String, dynamic> j) => PollModel(id: j['id'] as String, question: j['question'] as String, options: (j['options'] as List<dynamic>).cast<String>(), startDate: j['startDate'] != null ? DateTime.parse(j['startDate'] as String) : null, endDate: j['endDate'] != null ? DateTime.parse(j['endDate'] as String) : null, isSecret: j['isSecret'] as bool? ?? false, allowMultipleVotes: j['allowMultipleVotes'] as bool? ?? false, createdBy: j['createdBy'] as String?, societyId: j['societyId'] as String?, results: j['results'] as Map<String, dynamic>?, totalVotes: j['totalVotes'] as int?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class GroupModel extends GroupEntity {
  const GroupModel({required super.id, required super.name, super.memberUids, super.societyId, super.createdAt});
  factory GroupModel.fromJson(Map<String, dynamic> j) => GroupModel(id: j['id'] as String, name: j['name'] as String, memberUids: (j['memberUids'] as List<dynamic>?)?.cast<String>(), societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class MessageModel extends MessageEntity {
  const MessageModel({required super.id, required super.groupId, required super.senderId, required super.content, super.mediaUrl, super.createdAt});
  factory MessageModel.fromJson(Map<String, dynamic> j) => MessageModel(id: j['id'] as String, groupId: j['groupId'] as String, senderId: j['senderId'] as String, content: j['content'] as String, mediaUrl: j['mediaUrl'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}

class DocumentModel extends DocumentEntity {
  const DocumentModel({required super.id, required super.title, required super.fileUrl, required super.type, super.societyId, super.createdAt});
  factory DocumentModel.fromJson(Map<String, dynamic> j) => DocumentModel(id: j['id'] as String, title: j['title'] as String, fileUrl: j['fileUrl'] as String, type: j['type'] as String, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}
