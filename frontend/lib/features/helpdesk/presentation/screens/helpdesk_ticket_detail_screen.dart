import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class HelpdeskTicketDetailScreen extends StatelessWidget {
  const HelpdeskTicketDetailScreen({required this.ticketId, super.key});
  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text('Ticket #$ticketId', style: AppTypography.headingSmall)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.infoLight, borderRadius: BorderRadius.circular(4)), child: Text('OPEN', style: AppTypography.labelSmall.copyWith(color: AppColors.info))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text('Ticket description will appear here', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          ]))),
          const SizedBox(height: AppSpacing.md),
          // Status Timeline
          Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Status Timeline', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            _TimelineStep(label: 'Open', time: 'Created', isActive: true, isFirst: true),
            _TimelineStep(label: 'In Progress', time: 'Pending', isActive: false, isFirst: false),
            _TimelineStep(label: 'Resolved', time: 'Pending', isActive: false, isFirst: false),
            _TimelineStep(label: 'Closed', time: 'Pending', isActive: false, isFirst: false, isLast: true),
          ]))),
          const SizedBox(height: AppSpacing.md),
          // Comments
          Card(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Comments', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.md),
            Center(child: Text('No comments yet', style: AppTypography.bodySmall.copyWith(color: AppColors.grey500))),
          ]))),
          const SizedBox(height: AppSpacing.md),
          TextField(decoration: InputDecoration(hintText: 'Add a comment...', suffixIcon: IconButton(icon: const Icon(Icons.send_rounded), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Comment sent')))))),
        ]),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.label, required this.time, required this.isActive, required this.isFirst, this.isLast = false});
  final String label; final String time; final bool isActive; final bool isFirst; final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(width: 24, height: 24, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? AppColors.primary : AppColors.grey300), child: isActive ? const Icon(Icons.check, size: 14, color: Colors.white) : null),
        if (!isLast) Container(width: 2, height: 32, color: AppColors.grey200),
      ]),
      const SizedBox(width: AppSpacing.md),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTypography.titleSmall.copyWith(color: isActive ? AppColors.onSurface : AppColors.grey500)),
        Text(time, style: AppTypography.caption.copyWith(color: AppColors.grey500)),
        if (!isLast) const SizedBox(height: AppSpacing.md),
      ]),
    ]);
  }
}
