import 'package:flutter/material.dart';
import 'package:myguard_frontend/design_system/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 40.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(
          strokeWidth: 3,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class AppShimmerLoader extends StatelessWidget {
  const AppShimmerLoader({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : AppColors.shimmerBase,
      highlightColor: isDark ? AppColors.darkSurface : AppColors.shimmerHighlight,
      child: child,
    );
  }
}

class AppShimmerCard extends StatelessWidget {
  const AppShimmerCard({super.key, this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    return AppShimmerLoader(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class AppShimmerList extends StatelessWidget {
  const AppShimmerList({super.key, this.itemCount = 5, this.itemHeight = 80});

  final int itemCount;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => AppShimmerCard(height: itemHeight),
    );
  }
}
