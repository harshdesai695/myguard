import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class AmenityListScreen extends StatefulWidget {
  const AmenityListScreen({super.key});

  @override
  State<AmenityListScreen> createState() => _AmenityListScreenState();
}

class _AmenityListScreenState extends State<AmenityListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AmenityBloc>().add(const AmenitiesFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amenities')),
      body: BlocBuilder<AmenityBloc, AmenityState>(
        builder: (context, state) {
          if (state is AmenityLoading) return const AppShimmerList();
          if (state is AmenityError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<AmenityBloc>().add(const AmenitiesFetched()),
            );
          }
          if (state is AmenitiesLoaded) {
            if (state.amenities.isEmpty) {
              return const AppEmptyWidget(message: 'No amenities available', icon: Icons.sports_tennis_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<AmenityBloc>().add(const AmenitiesFetched()),
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.85,
                ),
                itemCount: state.amenities.length,
                itemBuilder: (context, index) {
                  final amenity = state.amenities[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: double.infinity,
                            color: AppColors.primaryLight.withValues(alpha: 0.1),
                            child: Icon(_getAmenityIcon(amenity.type), size: 48, color: AppColors.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(amenity.name, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(amenity.type, style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                                const SizedBox(height: AppSpacing.xs),
                                Row(
                                  children: [
                                    Icon(Icons.people_outline, size: 14, color: AppColors.grey500),
                                    const SizedBox(width: AppSpacing.xxs),
                                    Text('${amenity.capacity ?? '—'}', style: AppTypography.labelSmall),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: amenity.status == 'ACTIVE' ? AppColors.successLight : AppColors.grey100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        amenity.status ?? 'ACTIVE',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: amenity.status == 'ACTIVE' ? AppColors.success : AppColors.grey600,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

  IconData _getAmenityIcon(String type) => switch (type.toLowerCase()) {
        'gym' => Icons.fitness_center_rounded,
        'pool' || 'swimming' => Icons.pool_rounded,
        'clubhouse' || 'party hall' => Icons.celebration_rounded,
        'tennis' => Icons.sports_tennis_rounded,
        _ => Icons.sports_rounded,
      };
}
