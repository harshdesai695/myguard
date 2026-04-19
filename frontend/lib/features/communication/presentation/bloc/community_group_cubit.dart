import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/communication_usecases.dart';

sealed class GroupState extends Equatable { const GroupState(); @override List<Object?> get props => []; }
class GroupInitial extends GroupState { const GroupInitial(); }
class GroupLoading extends GroupState { const GroupLoading(); }
class GroupsLoaded extends GroupState { const GroupsLoaded({required this.groups, required this.hasMore}); final List<GroupEntity> groups; final bool hasMore; @override List<Object> get props => [groups, hasMore]; }
class MessagesLoaded extends GroupState { const MessagesLoaded({required this.messages, required this.hasMore}); final List<MessageEntity> messages; final bool hasMore; @override List<Object> get props => [messages, hasMore]; }
class GroupActionSuccess extends GroupState { const GroupActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class GroupError extends GroupState { const GroupError(this.message); final String message; @override List<Object> get props => [message]; }

class CommunityGroupCubit extends Cubit<GroupState> {
  CommunityGroupCubit({
    required GetGroupsUseCase getGroupsUseCase,
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  }) : _getGroupsUseCase = getGroupsUseCase,
       _getMessagesUseCase = getMessagesUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       super(const GroupInitial());
  final GetGroupsUseCase _getGroupsUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final List<GroupEntity> _groups = [];
  final List<MessageEntity> _messages = [];

  Future<void> loadGroups({int page = 0, String? societyId}) async {
    if (page == 0) { _groups.clear(); emit(const GroupLoading()); }
    final r = await _getGroupsUseCase(page: page, societyId: societyId);
    r.fold((f) => emit(GroupError(f.message)), (p) { _groups.addAll(p.content); emit(GroupsLoaded(groups: List.unmodifiable(_groups), hasMore: p.hasNext)); });
  }

  Future<void> loadMessages(String groupId, {int page = 0}) async {
    if (page == 0) { _messages.clear(); emit(const GroupLoading()); }
    final r = await _getMessagesUseCase(groupId, page: page);
    r.fold((f) => emit(GroupError(f.message)), (p) { _messages.addAll(p.content); emit(MessagesLoaded(messages: List.unmodifiable(_messages), hasMore: p.hasNext)); });
  }

  Future<void> sendMessage(String groupId, Map<String, dynamic> data) async {
    final r = await _sendMessageUseCase(groupId, data);
    r.fold((f) => emit(GroupError(f.message)), (_) => emit(const GroupActionSuccess('Message sent')));
  }
}
