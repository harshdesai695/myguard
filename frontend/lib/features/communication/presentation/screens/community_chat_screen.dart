import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/presentation/bloc/community_group_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({required this.groupId, super.key});
  final String groupId;

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CommunityGroupCubit>().loadMessages(widget.groupId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat')),
      body: BlocConsumer<CommunityGroupCubit, GroupState>(
        listener: (context, state) {
          if (state is GroupActionSuccess) {
            context.read<CommunityGroupCubit>().loadMessages(widget.groupId);
          } else if (state is GroupError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          final List<MessageEntity> messages = state is MessagesLoaded ? state.messages : [];
          final isLoading = state is GroupLoading;

          return Column(
            children: [
              Expanded(
                child: isLoading
                    ? const AppShimmerList()
                    : messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AppColors.grey400),
                                const SizedBox(height: AppSpacing.sm),
                                Text('No messages yet', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)),
                                Text('Start the conversation!', style: AppTypography.bodySmall.copyWith(color: AppColors.grey400)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(msg.senderId, style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                                      Text(msg.content, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey900)),
                                      const SizedBox(height: 2),
                                      if (msg.createdAt != null) Text('${msg.createdAt!.hour}:${msg.createdAt!.minute.toString().padLeft(2, '0')}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [BoxShadow(color: AppColors.grey300.withValues(alpha: 0.5), blurRadius: 4, offset: const Offset(0, -2))],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            filled: true,
                            fillColor: AppColors.grey100,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                          minLines: 1,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      IconButton.filled(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded),
                        style: IconButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    context.read<CommunityGroupCubit>().sendMessage(widget.groupId, {'content': text});
  }
}
