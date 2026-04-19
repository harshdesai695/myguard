import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class EmergencyContactManagementScreen extends StatefulWidget {
  const EmergencyContactManagementScreen({super.key});

  @override
  State<EmergencyContactManagementScreen> createState() =>
      _EmergencyContactManagementScreenState();
}

class _EmergencyContactManagementScreenState
    extends State<EmergencyContactManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmergencyCubit>().loadContacts();
  }

  void _showAddContactSheet() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    var selectedType = 'OTHER';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add Emergency Contact', style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'POLICE', child: Text('Police')),
                  DropdownMenuItem(value: 'FIRE', child: Text('Fire')),
                  DropdownMenuItem(value: 'AMBULANCE', child: Text('Ambulance')),
                  DropdownMenuItem(value: 'HOSPITAL', child: Text('Hospital')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (v) => setSheetState(() => selectedType = v ?? 'OTHER'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address (optional)'),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () {
                  final authState = context.read<AuthBloc>().state;
                  final societyId = (authState is AuthAuthenticated)
                      ? authState.user.societyId ?? ''
                      : '';
                  context.read<EmergencyCubit>().createContact({
                    'name': nameController.text.trim(),
                    'phone': phoneController.text.trim(),
                    'type': selectedType,
                    'address': addressController.text.trim(),
                    'societyId': societyId,
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddContactSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Contact'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocConsumer<EmergencyCubit, EmergencyState>(
        listener: (context, state) {
          if (state is EmergencyActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<EmergencyCubit>().loadContacts();
          }
          if (state is EmergencyError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is EmergencyLoading) {
            return const AppShimmerList();
          }
          if (state is EmergencyError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<EmergencyCubit>().loadContacts(),
            );
          }
          if (state is EmergencyContactsLoaded) {
            final contacts = state.contacts;
            if (contacts.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<EmergencyCubit>().loadContacts(),
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    AppEmptyWidget(
                      message: 'No emergency contacts yet.',
                      icon: Icons.emergency_outlined,
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<EmergencyCubit>().loadContacts(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: contacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        _iconForType(contact.type),
                        color: AppColors.primary,
                      ),
                      title: Text(contact.name, style: AppTypography.bodyMedium),
                      subtitle: Text(
                        '${contact.type} • ${contact.phone}',
                        style: AppTypography.caption,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                        onPressed: () => context.read<EmergencyCubit>().deleteContact(contact.id),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'POLICE':
        return Icons.local_police_rounded;
      case 'FIRE':
        return Icons.local_fire_department_rounded;
      case 'AMBULANCE':
        return Icons.emergency_rounded;
      case 'HOSPITAL':
        return Icons.local_hospital_rounded;
      default:
        return Icons.phone_rounded;
    }
  }
}
