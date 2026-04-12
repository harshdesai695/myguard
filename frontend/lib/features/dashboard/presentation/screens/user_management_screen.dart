import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});
  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('User Management'), bottom: const TabBar(tabs: [Tab(text: 'Residents'), Tab(text: 'Guards'), Tab(text: 'Admins')])),
      body: _loading ? const AppShimmerList() : RefreshIndicator(onRefresh: _load, child: ListView(children: const [
        SizedBox(height: 200),
        AppEmptyWidget(message: 'No users found.\nPull to refresh or connect backend API.', icon: Icons.people_outlined),
      ])),
    ));
  }
}
