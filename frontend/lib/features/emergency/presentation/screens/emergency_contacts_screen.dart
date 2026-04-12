import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/emergency/presentation/bloc/emergency_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmergencyCubit>().loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency')),
      body: BlocBuilder<EmergencyCubit, EmergencyState>(
        builder: (context, state) {
          if (state is EmergencyLoading) return const AppShimmerList();
          if (state is EmergencyError) return AppErrorWidget(message: state.message, onRetry: () => context.read<EmergencyCubit>().loadContacts());
          if (state is EmergencyContactsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Panic Button
                  Card(
                    color: AppColors.error,
                    child: InkWell(
                      onTap: () => _showPanicConfirmation(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                              child: const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('SOS / Panic', style: AppTypography.headingMedium.copyWith(color: Colors.white)),
                                  Text('Press and hold for emergency alert', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Emergency Contacts', style: AppTypography.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.contacts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: Text('No emergency contacts configured')),
                    )
                  else
                    ...state.contacts.map((contact) => Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.errorLight,
                              child: Icon(_contactIcon(contact.type), color: AppColors.error),
                            ),
                            title: Text(contact.name, style: AppTypography.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contact.type, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                                Text(contact.phone, style: AppTypography.bodySmall),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone_rounded, color: AppColors.success),
                              onPressed: () {},
                            ),
                          ),
                        )),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPanicConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Trigger Panic Alert?'),
        content: const Text('This will alert all security guards and administrators immediately. Use only in emergencies.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<EmergencyCubit>().triggerPanic({'description': 'SOS triggered', 'societyId': ''});
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('TRIGGER SOS'),
          ),
        ],
      ),
    );
  }

  IconData _contactIcon(String type) => switch (type.toLowerCase()) {
        'police' => Icons.local_police_rounded,
        'fire' => Icons.local_fire_department_rounded,
        'ambulance' => Icons.local_hospital_rounded,
        'hospital' => Icons.medical_services_rounded,
        _ => Icons.phone_rounded,
      };
}
