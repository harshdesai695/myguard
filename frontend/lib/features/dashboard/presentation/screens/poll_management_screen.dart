import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class PollManagementScreen extends StatefulWidget {
  const PollManagementScreen({super.key});
  @override
  State<PollManagementScreen> createState() => _PollManagementScreenState();
}
class _PollManagementScreenState extends State<PollManagementScreen> {
  bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    // GET /api/v1/communications/polls
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poll Management')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push('/admin/polls/create'), icon: const Icon(Icons.add_rounded), label: Text('Create Poll'), backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary),
      body: _loading ? const AppShimmerList() : RefreshIndicator(onRefresh: _load, child: ListView(children: [
        const SizedBox(height: 200),
        AppEmptyWidget(message: 'No data yet. Pull to refresh.', icon: Icons.poll_outlined, actionLabel: 'Refresh', onAction: _load),
      ])),
    );
  }
}
