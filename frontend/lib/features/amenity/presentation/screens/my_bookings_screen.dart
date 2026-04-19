import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/injection.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AmenityBloc>()..add(const MyBookingsFetched()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: BlocBuilder<AmenityBloc, AmenityState>(
          builder: (context, state) {
            if (state is AmenityLoading) return const AppShimmerList();
            if (state is AmenityError) return AppErrorWidget(message: state.message, onRetry: () => context.read<AmenityBloc>().add(const MyBookingsFetched()));
            if (state is BookingsLoaded) {
              if (state.bookings.isEmpty) return const AppEmptyWidget(message: 'No bookings yet', icon: Icons.calendar_today_outlined);
              return RefreshIndicator(
                onRefresh: () async => context.read<AmenityBloc>().add(const MyBookingsFetched()),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    final b = state.bookings[index];
                    final statusColor = switch (b.status) {
                      'CONFIRMED' => AppColors.success,
                      'CANCELLED' => AppColors.error,
                      'CHECKED_IN' => AppColors.primary,
                      _ => AppColors.warning,
                    };
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: CircleAvatar(
                          backgroundColor: statusColor.withValues(alpha: 0.1),
                          child: Icon(Icons.event_rounded, color: statusColor),
                        ),
                        title: Text('${b.slotDate}  ${b.startTime} - ${b.endTime}', style: AppTypography.titleSmall),
                        subtitle: Text('Amenity: ${b.amenityId}', style: AppTypography.caption.copyWith(color: AppColors.grey600)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(b.status, style: AppTypography.labelSmall.copyWith(color: statusColor)),
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
      ),
    );
  }
}
