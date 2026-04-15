import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/amenity/presentation/bloc/amenity_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({required this.bookingId, super.key});
  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: BlocBuilder<AmenityBloc, AmenityState>(
        builder: (context, state) {
          if (state is AmenityLoading) return const AppLoader();
          if (state is AmenityError) return AppErrorWidget(message: state.message);
          if (state is BookingsLoaded) {
            final booking = state.bookings.where((b) => b.id == bookingId).firstOrNull;
            if (booking == null) return const AppErrorWidget(message: 'Booking not found');
            final statusColor = switch (booking.status) { 'CONFIRMED' => AppColors.success, 'CANCELLED' => AppColors.error, 'CHECKED_IN' => AppColors.primary, _ => AppColors.warning };
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(booking.status, style: AppTypography.labelLarge.copyWith(color: statusColor)),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const Icon(Icons.event_available_rounded, size: 48, color: AppColors.primary),
                          const SizedBox(height: AppSpacing.sm),
                          Text(booking.slotDate, style: AppTypography.headingSmall),
                          Text('${booking.startTime} - ${booking.endTime}', style: AppTypography.bodyLarge.copyWith(color: AppColors.grey600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _DetailRow(icon: Icons.sports_tennis_outlined, label: 'Amenity', value: booking.amenityId),
                          const Divider(height: 1),
                          _DetailRow(icon: Icons.people_outline_rounded, label: 'Notes', value: booking.notes ?? 'N/A'),
                          const Divider(height: 1),
                          _DetailRow(icon: Icons.apartment_outlined, label: 'Flat', value: booking.flatId ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                  if (booking.status == 'CONFIRMED') ...[
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.read<AmenityBloc>().add(BookingCancelled(booking.id)),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Booking'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          minimumSize: const Size(0, 48),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.grey500),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
          const Spacer(),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}
