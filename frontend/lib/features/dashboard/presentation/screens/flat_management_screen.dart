import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myguard_frontend/features/auth/presentation/bloc/auth_state.dart';
import 'package:myguard_frontend/features/society/presentation/bloc/society_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';
import 'package:myguard_frontend/shared/widgets/app_text_field.dart';

class FlatManagementScreen extends StatefulWidget {
  const FlatManagementScreen({super.key});

  @override
  State<FlatManagementScreen> createState() => _FlatManagementScreenState();
}

class _FlatManagementScreenState extends State<FlatManagementScreen> {
  String get _societyId {
    final authState = context.read<AuthBloc>().state;
    return (authState is AuthAuthenticated) ? authState.user.societyId ?? '' : '';
  }

  @override
  void initState() {
    super.initState();
    if (_societyId.isNotEmpty) {
      context.read<SocietyBloc>().add(FlatsFetched(societyId: _societyId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flat Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateFlatDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Flat'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocConsumer<SocietyBloc, SocietyState>(
        listener: (context, state) {
          if (state is SocietyActionSuccess) {
            AppSnackbar.success(context, message: state.message);
            context.read<SocietyBloc>().add(FlatsFetched(societyId: _societyId));
          }
          if (state is SocietyError) {
            AppSnackbar.error(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is SocietyLoading) return const AppShimmerList();
          if (state is SocietyError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<SocietyBloc>().add(FlatsFetched(societyId: _societyId)),
            );
          }
          if (state is FlatsLoaded) {
            if (state.flats.isEmpty) {
              return const AppEmptyWidget(
                message: 'No flats added yet.\nTap + to add a flat.',
                icon: Icons.door_front_door_outlined,
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<SocietyBloc>().add(FlatsFetched(societyId: _societyId)),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.flats.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.flats.length) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: AppLoader(size: 24),
                    );
                  }
                  final flat = state.flats[index];
                  final isOccupied = flat.status == 'OCCUPIED';
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      leading: CircleAvatar(
                        backgroundColor: isOccupied
                            ? AppColors.successLight
                            : AppColors.grey100,
                        child: Icon(
                          Icons.door_front_door_rounded,
                          color: isOccupied ? AppColors.success : AppColors.grey500,
                        ),
                      ),
                      title: Text(
                        '${flat.block}-${flat.flatNumber}',
                        style: AppTypography.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (flat.flatType != null)
                            Text(flat.flatType!, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                          if (flat.area != null)
                            Text('${flat.area} sq.ft', style: AppTypography.bodySmall),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isOccupied ? AppColors.successLight : AppColors.warningLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          flat.status ?? 'VACANT',
                          style: AppTypography.labelSmall.copyWith(
                            color: isOccupied ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          // Default: show empty state with info
          return AppErrorWidget(
            message: 'Connect to backend to load flats.',
            onRetry: () {
              if (_societyId.isNotEmpty) {
                context.read<SocietyBloc>().add(FlatsFetched(societyId: _societyId));
              }
            },
          );
        },
      ),
    );
  }

  void _showCreateFlatDialog(BuildContext context) {
    final blockC = TextEditingController();
    final numberC = TextEditingController();
    final typeC = TextEditingController();
    final areaC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Flat', style: AppTypography.headingSmall),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Block', controller: blockC, hint: 'e.g., A, B, Tower-1', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Flat Number', controller: numberC, hint: 'e.g., 101, 202', validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Type (Optional)', controller: typeC, hint: 'e.g., 1BHK, 2BHK, 3BHK'),
              const SizedBox(height: AppSpacing.md),
              AppTextField(label: 'Area sq.ft (Optional)', controller: areaC, hint: 'e.g., 850', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Create Flat',
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    context.read<SocietyBloc>().add(FlatCreated(
                      societyId: _societyId,
                      data: {
                        'block': blockC.text.trim(),
                        'flatNumber': numberC.text.trim(),
                        if (typeC.text.trim().isNotEmpty) 'flatType': typeC.text.trim(),
                        if (areaC.text.trim().isNotEmpty) 'area': double.tryParse(areaC.text.trim()),
                      },
                    ));
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
