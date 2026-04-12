import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/shared/widgets/app_button.dart';

class AmenityBookingScreen extends StatefulWidget {
  const AmenityBookingScreen({required this.amenityId, super.key});
  final String amenityId;
  @override
  State<AmenityBookingScreen> createState() => _AmenityBookingScreenState();
}

class _AmenityBookingScreenState extends State<AmenityBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedSlot = -1;

  final _slots = ['06:00 - 07:00', '07:00 - 08:00', '08:00 - 09:00', '09:00 - 10:00', '10:00 - 11:00', '16:00 - 17:00', '17:00 - 18:00', '18:00 - 19:00', '19:00 - 20:00'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Amenity')),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: AppButton(label: 'Confirm Booking', onPressed: _selectedSlot >= 0 ? () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking confirmed!'))); context.pop(); } : null))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Select Date', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(height: 80, child: ListView.builder(
            scrollDirection: Axis.horizontal, itemCount: 14,
            itemBuilder: (_, i) {
              final date = DateTime.now().add(Duration(days: i));
              final selected = date.day == _selectedDate.day && date.month == _selectedDate.month;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: Container(
                  width: 56, margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.md)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1], style: AppTypography.labelSmall.copyWith(color: selected ? Colors.white : AppColors.grey500)),
                    Text('${date.day}', style: AppTypography.headingSmall.copyWith(color: selected ? Colors.white : AppColors.onSurface)),
                  ]),
                ),
              );
            },
          )),
          const SizedBox(height: AppSpacing.lg),
          Text('Available Slots', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: List.generate(_slots.length, (i) => ChoiceChip(
            label: Text(_slots[i]), selected: _selectedSlot == i,
            onSelected: (s) => setState(() => _selectedSlot = s ? i : -1),
            selectedColor: AppColors.primary, labelStyle: TextStyle(color: _selectedSlot == i ? Colors.white : AppColors.onSurface),
          ))),
        ]),
      ),
    );
  }
}
