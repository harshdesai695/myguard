import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(const ListingsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/resident/marketplace/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Listing'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) return const AppShimmerList();
          if (state is MarketplaceError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MarketplaceBloc>().add(const ListingsFetched()));
          if (state is ListingsLoaded) {
            if (state.listings.isEmpty) return const AppEmptyWidget(message: 'No listings yet', icon: Icons.storefront_outlined);
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.listings.length,
              itemBuilder: (context, index) {
                final listing = state.listings[index];
                final statusColor = switch (listing.status) { 'SOLD' => AppColors.grey500, 'EXPIRED' => AppColors.error, _ => AppColors.success };
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () => context.push('/resident/marketplace/${listing.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: listing.photos != null && listing.photos!.isNotEmpty
                                ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(listing.photos!.first, fit: BoxFit.cover))
                                : const Icon(Icons.image_outlined, color: AppColors.grey400),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listing.title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text(listing.price > 0 ? '₹${listing.price.toStringAsFixed(0)}' : 'Free', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(listing.status, style: AppTypography.labelSmall.copyWith(color: statusColor)),
                          ),
                        ],
                      ),
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
}
