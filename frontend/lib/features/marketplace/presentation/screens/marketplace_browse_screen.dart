import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_empty_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_error_widget.dart';
import 'package:myguard_frontend/shared/widgets/app_loader.dart';

class MarketplaceBrowseScreen extends StatefulWidget {
  const MarketplaceBrowseScreen({super.key});

  @override
  State<MarketplaceBrowseScreen> createState() => _MarketplaceBrowseScreenState();
}

class _MarketplaceBrowseScreenState extends State<MarketplaceBrowseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(const ListingsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Sell'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) return const AppShimmerList();
          if (state is MarketplaceError) return AppErrorWidget(message: state.message, onRetry: () => context.read<MarketplaceBloc>().add(const ListingsFetched()));
          if (state is ListingsLoaded) {
            if (state.listings.isEmpty) return const AppEmptyWidget(message: 'No listings yet', icon: Icons.storefront_outlined);
            return RefreshIndicator(
              onRefresh: () async => context.read<MarketplaceBloc>().add(const ListingsFetched()),
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: AppSpacing.sm, crossAxisSpacing: AppSpacing.sm, childAspectRatio: 0.75,
                ),
                itemCount: state.listings.length,
                itemBuilder: (context, index) {
                  final listing = state.listings[index];
                  final conditionColor = switch (listing.condition) { 'NEW' => AppColors.success, 'LIKE_NEW' => AppColors.primary, _ => AppColors.grey600 };
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120, width: double.infinity,
                            color: AppColors.grey100,
                            child: listing.photos != null && listing.photos!.isNotEmpty
                                ? Image.network(listing.photos!.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, size: 48, color: AppColors.grey400))
                                : const Icon(Icons.image_outlined, size: 48, color: AppColors.grey400),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listing.title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: AppSpacing.xxs),
                                Text('₹${listing.price.toStringAsFixed(0)}', style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                                const SizedBox(height: AppSpacing.xs),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: conditionColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                  child: Text(listing.condition.replaceAll('_', ' '), style: AppTypography.labelSmall.copyWith(color: conditionColor, fontSize: 9)),
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
}
