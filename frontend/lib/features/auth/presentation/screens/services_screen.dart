import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            _ServiceTile(icon: Icons.cleaning_services_outlined, label: 'Daily Help', onTap: () => context.push('/resident/daily-help')),
            _ServiceTile(icon: Icons.pool_outlined, label: 'Amenities', onTap: () => context.push('/resident/amenities')),
            _ServiceTile(icon: Icons.support_agent_outlined, label: 'Helpdesk', onTap: () => context.push('/resident/helpdesk')),
            _ServiceTile(icon: Icons.directions_car_outlined, label: 'Vehicles', onTap: () => context.push('/resident/vehicles')),
            _ServiceTile(icon: Icons.local_shipping_outlined, label: 'Gate Pass', onTap: () => context.push('/resident/material-gatepass')),
            _ServiceTile(icon: Icons.pets_outlined, label: 'Pets', onTap: () => context.push('/resident/pets')),
            _ServiceTile(icon: Icons.store_outlined, label: 'Marketplace', onTap: () => context.push('/resident/marketplace')),
            _ServiceTile(icon: Icons.warning_amber_outlined, label: 'Emergency', onTap: () => context.push('/resident/emergency')),
            _ServiceTile(icon: Icons.description_outlined, label: 'Documents', onTap: () => context.push('/resident/documents')),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
