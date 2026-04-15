import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/pet/presentation/bloc/pet_cubit.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';
import 'package:go_router/go_router.dart';

class PetDirectoryScreen extends StatefulWidget {
  const PetDirectoryScreen({super.key});

  @override
  State<PetDirectoryScreen> createState() => _PetDirectoryScreenState();
}

class _PetDirectoryScreenState extends State<PetDirectoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PetCubit>().loadPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Directory')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resident/pets/register'),
        icon: const Icon(Icons.pets_rounded),
        label: const Text('Register Pet'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetLoading) return const AppShimmerList();
          if (state is PetError) return AppErrorWidget(message: state.message, onRetry: () => context.read<PetCubit>().loadPets());
          if (state is PetsLoaded) {
            if (state.pets.isEmpty) return const AppEmptyWidget(message: 'No pets registered', icon: Icons.pets_outlined);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                      backgroundImage: pet.photoUrl != null ? NetworkImage(pet.photoUrl!) : null,
                      child: pet.photoUrl == null ? Icon(_petIcon(pet.type), color: AppColors.secondary) : null,
                    ),
                    title: Text(pet.name, style: AppTypography.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${pet.breed ?? pet.type} • ${pet.age ?? '?'} yrs', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                        const SizedBox(height: AppSpacing.xxs),
                        Row(children: [
                          Icon(Icons.vaccines_outlined, size: 14, color: pet.vaccinationStatus == 'UP_TO_DATE' ? AppColors.success : AppColors.warning),
                          const SizedBox(width: 4),
                          Text(pet.vaccinationStatus ?? 'Unknown', style: AppTypography.labelSmall.copyWith(color: AppColors.grey600)),
                        ]),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  IconData _petIcon(String type) => switch (type.toLowerCase()) { 'dog' => Icons.pets_rounded, 'cat' => Icons.pets_rounded, 'bird' => Icons.flutter_dash_rounded, _ => Icons.pets_rounded };
}
