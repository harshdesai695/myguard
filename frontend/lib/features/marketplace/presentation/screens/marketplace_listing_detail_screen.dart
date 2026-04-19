import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:myguard_frontend/design_system/app_spacing.dart';
import 'package:myguard_frontend/design_system/app_typography.dart';
import 'package:myguard_frontend/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:myguard_frontend/shared/widgets/app_snackbar.dart';

class MarketplaceListingDetailScreen extends StatefulWidget {
  const MarketplaceListingDetailScreen({required this.listingId, super.key});
  final String listingId;

  @override
  State<MarketplaceListingDetailScreen> createState() => _MarketplaceListingDetailScreenState();
}

class _MarketplaceListingDetailScreenState extends State<MarketplaceListingDetailScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<MarketplaceBloc>().state;
    if (state is! ListingsLoaded) {
      context.read<MarketplaceBloc>().add(const ListingsFetched());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketplaceBloc, MarketplaceState>(
      listener: (context, state) {
        if (state is MarketplaceActionSuccess) {
          AppSnackbar.success(context, message: state.message);
        } else if (state is MarketplaceError) {
          AppSnackbar.error(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is MarketplaceLoading) {
          return Scaffold(appBar: AppBar(title: const Text('Listing Details')), body: const Center(child: CircularProgressIndicator()));
        }
        if (state is MarketplaceError) {
          return Scaffold(appBar: AppBar(title: const Text('Listing Details')), body: Center(child: Text(state.message)));
        }
        if (state is ListingsLoaded) {
          final listing = state.listings.where((l) => l.id == widget.listingId).firstOrNull;
          if (listing == null) {
            return Scaffold(appBar: AppBar(title: const Text('Listing Details')), body: const Center(child: Text('Listing not found')));
          }
          final conditionColor = switch (listing.condition) {
            'NEW' => AppColors.success,
            'LIKE_NEW' => AppColors.info,
            _ => AppColors.warning,
          };
          return Scaffold(
            appBar: AppBar(title: const Text('Listing Details')),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilledButton.icon(
                  onPressed: () {
                    context.read<MarketplaceBloc>().add(InterestExpressed(listingId: listing.id, data: const {'message': 'I am interested in this listing'}));
                  },
                  icon: const Icon(Icons.favorite_border_rounded),
                  label: const Text("I'm Interested"),
                  style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(AppSpacing.md)),
                  child: listing.photos != null && listing.photos!.isNotEmpty
                      ? ClipRRect(borderRadius: BorderRadius.circular(AppSpacing.md), child: Image.network(listing.photos!.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, size: 64, color: AppColors.grey400)))
                      : const Icon(Icons.image_outlined, size: 64, color: AppColors.grey400),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(listing.title, style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.xs),
                Text('₹${listing.price.toStringAsFixed(0)}', style: AppTypography.headingLarge.copyWith(color: AppColors.primary)),
                const SizedBox(height: AppSpacing.sm),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: conditionColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(listing.condition, style: AppTypography.labelSmall.copyWith(color: conditionColor))),
                  const SizedBox(width: AppSpacing.sm),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(4)), child: Text(listing.category, style: AppTypography.labelSmall.copyWith(color: AppColors.grey600))),
                  const SizedBox(width: AppSpacing.sm),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: listing.status == 'ACTIVE' ? AppColors.successLight : AppColors.warningLight, borderRadius: BorderRadius.circular(4)), child: Text(listing.status, style: AppTypography.labelSmall.copyWith(color: listing.status == 'ACTIVE' ? AppColors.success : AppColors.warning))),
                ]),
                const SizedBox(height: AppSpacing.lg),
                Text('Description', style: AppTypography.titleMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(listing.description, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600)),
                const SizedBox(height: AppSpacing.lg),
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(listing.postedBy ?? 'Seller'),
                    subtitle: const Text('Tap chat icon to contact'),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat_outlined, color: AppColors.primary),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Contact Seller'),
                            content: const Text('Contact the seller at their registered phone number listed in the society directory.'),
                            actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
        return Scaffold(appBar: AppBar(title: const Text('Listing Details')), body: const Center(child: CircularProgressIndicator()));
      },
    );
  }
}
