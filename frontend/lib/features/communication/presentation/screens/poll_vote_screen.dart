import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class PollVoteScreen extends StatefulWidget {
  const PollVoteScreen({required this.pollId, super.key});
  final String pollId;
  @override
  State<PollVoteScreen> createState() => _PollVoteScreenState();
}

class _PollVoteScreenState extends State<PollVoteScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final options = ['Option A', 'Option B', 'Option C', 'Option D'];
    return Scaffold(
      appBar: AppBar(title: const Text('Vote')),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: FilledButton(onPressed: _selected != null ? () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vote submitted'))); Navigator.pop(context); } : null, style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)), child: const Text('Submit Vote')))),
      body: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Poll Question', style: AppTypography.headingMedium),
        Text('ID: ${widget.pollId}', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
        const SizedBox(height: AppSpacing.lg),
        ...options.map((o) => RadioListTile<String>(value: o, groupValue: _selected, onChanged: (v) => setState(() => _selected = v), title: Text(o), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.sm)))),
      ])),
    );
  }
}
