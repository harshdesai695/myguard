import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MoveInOutScreen extends StatefulWidget {
  const MoveInOutScreen({super.key});
  @override
  State<MoveInOutScreen> createState() => _MoveInOutScreenState();
}
class _MoveInOutScreenState extends State<MoveInOutScreen> {
  bool _loading = true;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() => _loading = true);
    // GET /api/v1/dashboard/move-in-out
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move In/Out')),
      body: _loading ? const AppShimmerList() : RefreshIndicator(onRefresh: _load, child: ListView(children: [
        const SizedBox(height: 200),
        AppEmptyWidget(message: 'No data yet. Pull to refresh.', icon: Icons.swap_vert_rounded, actionLabel: 'Refresh', onAction: _load),
      ])),
    );
  }
}
