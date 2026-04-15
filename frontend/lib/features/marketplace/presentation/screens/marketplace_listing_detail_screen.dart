import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';

class MarketplaceListingDetailScreen extends StatelessWidget {
  const MarketplaceListingDetailScreen({required this.listingId, super.key});
  final String listingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listing Details')),
      bottomNavigationBar: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Interest expressed'))), icon: const Icon(Icons.favorite_border_rounded), label: const Text("I'm Interested"), style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48))))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.md), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 250, width: double.infinity, decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(AppSpacing.md)), child: const Icon(Icons.image_outlined, size: 64, color: AppColors.grey400)),
        const SizedBox(height: AppSpacing.md),
        Text('Listing Title', style: AppTypography.headingMedium),
        const SizedBox(height: AppSpacing.xs),
        Text('₹0', style: AppTypography.headingLarge.copyWith(color: AppColors.primary)),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(4)), child: Text('NEW', style: AppTypography.labelSmall.copyWith(color: AppColors.success))),
          const SizedBox(width: AppSpacing.sm),
          Text('ID: $listingId', style: AppTypography.caption.copyWith(color: AppColors.grey500)),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Description', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Listing description will be loaded from the API.', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
        const SizedBox(height: AppSpacing.lg),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: const Text('Seller'), subtitle: const Text('Contact details'), trailing: IconButton(icon: const Icon(Icons.chat_outlined, color: AppColors.primary), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat with seller - coming soon')))))),
      ])),
    );
  }
}
