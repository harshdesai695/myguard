import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AmenityBloc>().add(const AdminBookingsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Management')),
      body: BlocBuilder<AmenityBloc, AmenityState>(
        builder: (context, state) {
          if (state is AmenityLoading) return const AppShimmerList();
          if (state is AmenityError) {
            return AppErrorWidget(message: state.message, onRetry: () => context.read<AmenityBloc>().add(const AdminBookingsFetched()));
          }
          if (state is BookingsLoaded) {
            if (state.bookings.isEmpty) {
              return const AppEmptyWidget(message: 'No bookings found', icon: Icons.book_online_outlined);
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<AmenityBloc>().add(const MyBookingsFetched()),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  final statusColor = switch (booking.status) {
                    'CONFIRMED' => AppColors.success,
                    'CANCELLED' => AppColors.error,
                    'CHECKED_IN' => AppColors.primary,
                    'CHECKED_OUT' => AppColors.grey500,
                    _ => AppColors.warning,
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      title: Text('${booking.slotDate} • ${booking.startTime} - ${booking.endTime}', style: AppTypography.titleSmall),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amenity: ${booking.amenityId}', style: AppTypography.bodySmall.copyWith(color: AppColors.grey600)),
                          if (booking.notes != null) Text(booking.notes!, style: AppTypography.caption.copyWith(color: AppColors.grey500)),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(booking.status.replaceAll('_', ' '), style: AppTypography.labelSmall.copyWith(color: statusColor)),
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
}
